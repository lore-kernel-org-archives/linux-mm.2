Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E97D5B871
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906E96B0088; Mon, 15 Dec 2025 16:40:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E87D6B0089; Mon, 15 Dec 2025 16:40:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7B16B008A; Mon, 15 Dec 2025 16:40:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5EEBD6B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:40:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10317B8D26
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:40:56 +0000 (UTC)
X-FDA: 84223025712.13.727D939
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6247A80009
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:40:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJFBVJaC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765834854; a=rsa-sha256;
	cv=none;
	b=lXTZr1511W0d0+QHaNdscDSYHLW84A2xg6ClK/2kDUOvOvyF+jtG73ycombK1TP37ODqwR
	piqZhd/4qYpAF8xA7krfXXIJyuy+GQUyMEcVFdkABy8U4vjspf8zyhr6CIqv+g7SPjdWOc
	rz89Nkq0C/+QVeoTXPdGkOaS88jxFRc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJFBVJaC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765834854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ReJbb2QYcRTe1sN1kR2drh1hU6eWHE+ARxQsZGppZsU=;
	b=gq4/ynYcGVlr1zK7UxCut2suV8J57cSXVOfL4ieiOOiq/t+ecfUW6yd7LzzED3navGNUYh
	QWhLak0kI+6kXYCbJU8wtRE2BPzDAPD4Ic3k5f7qCQfz8flI1Z1uB/SisO7vkHQ35nJjjh
	+DVfoAseGCJcKeYoTfO9CRI6NWUg2rQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EAC11440D9;
	Mon, 15 Dec 2025 21:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C486BC4CEF5;
	Mon, 15 Dec 2025 21:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765834852;
	bh=8+QhW2cFWJDaIsuT5yDSI4nyUtquLCwiDgHnqtP3F00=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=qJFBVJaC0an3Wy7ck/NW3yKgi9jI3ce1I7gVQW8XUmK+OrJgE8FAW+WL7g4D9LvFe
	 /YXSYPoFx2CSzUrpqi11o2qDr8G6z/1Di0ZaklBXTyTMLUzpgYiEXa6CG+nuC9aEPB
	 oPLpWQpGwbvBrApASVSXJtWBeD5j9+j8eCEqoYfQukbOTAQU4/7mRVkdeQh7josQjH
	 EqqCHJPOqdShwjRa6dHuASX87J1if9DJv4RbmhpyPx7LNZQF9y9tpD3TU8/KUvv9Fl
	 o6XLqSg9GmBVn/+MChjQ3SmuTHxo55lUfl8ovjSyyVqKmJtl1P2uKHl4dlIN5739w4
	 bHhzsM+PVC1lg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 15 Dec 2025 22:40:36 +0100
Message-Id: <DEZ47GQSH2NC.UBRRY2WDHUJJ@kernel.org>
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Dave Ertman"
 <david.m.ertman@intel.com>, "Ira Weiny" <ira.weiny@intel.com>, "Leon
 Romanovsky" <leon@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>,
 "Boqun Feng" <boqun.feng@gmail.com>, "Elle Rhumsaa"
 <elle@weathered-steel.dev>, "Carlos Llamas" <cmllamas@google.com>, "Yury
 Norov" <yury.norov@gmail.com>, "Andreas Hindborg" <a.hindborg@kernel.org>,
 <linux-block@vger.kernel.org>, "FUJITA Tomonori"
 <fujita.tomonori@gmail.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Michael
 Turquette" <mturquette@baylibre.com>, "Stephen Boyd" <sboyd@kernel.org>,
 <linux-clk@vger.kernel.org>, "Benno Lossin" <lossin@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "Viresh Kumar" <viresh.kumar@linaro.org>, <linux-pm@vger.kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Serge Hallyn" <sergeh@kernel.org>,
 <linux-security-module@vger.kernel.org>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Abdiel Janulgue"
 <abdiel.janulgue@gmail.com>, "Robin Murphy" <robin.murphy@arm.com>, "Lyude
 Paul" <lyude@redhat.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 <linux-fsdevel@vger.kernel.org>, "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Jason Baron" <jbaron@akamai.com>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Ard Biesheuvel" <ardb@kernel.org>, "Brendan Higgins"
 <brendan.higgins@linux.dev>, "David Gow" <davidgow@google.com>, "Rae Moar"
 <rmoar@google.com>, <linux-kselftest@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Andrew Ballance" <andrewjballance@gmail.com>,
 <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Uladzislau Rezki" <urezki@gmail.com>,
 "Vitaly Wool" <vitaly.wool@konsulko.se>, "Rob Herring" <robh@kernel.org>,
 "Saravana Kannan" <saravanak@google.com>, <devicetree@vger.kernel.org>,
 "Bjorn Helgaas" <bhelgaas@google.com>,
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 <linux-pci@vger.kernel.org>, "Remo Senekowitsch" <remo@buenzli.dev>, "Paul
 E. McKenney" <paulmck@kernel.org>, <rcu@vger.kernel.org>, "Will Deacon"
 <will@kernel.org>, "Fiona Behrens" <me@kloenk.dev>, "Gary Guo"
 <gary@garyguo.net>, "Liam Girdwood" <lgirdwood@gmail.com>, "Mark Brown"
 <broonie@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>, "Vlastimil
 Babka" <vbabka@suse.cz>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Ingo Molnar" <mingo@redhat.com>, "Waiman
 Long" <longman@redhat.com>, "Mitchell Levy" <levymitchell0@gmail.com>,
 "Frederic Weisbecker" <frederic@kernel.org>, "Anna-Maria Behnsen"
 <anna-maria@linutronix.de>, "John Stultz" <jstultz@google.com>,
 <linux-usb@vger.kernel.org>, "Tejun Heo" <tj@kernel.org>, "Lai Jiangshan"
 <jiangshanlai@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Tamir
 Duberstein" <tamird@gmail.com>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH 00/46] Allow inlining C helpers into Rust when using LTO
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
In-Reply-To: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
X-Rspamd-Queue-Id: 6247A80009
X-Stat-Signature: oxs9n9mebm5e6qgk3icodut8dntupa5i
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765834854-501954
X-HE-Meta: U2FsdGVkX1/swyo6vpMggmOpAcRieYNJ153gcAbwflZkTxYP6gWQvhEzZLaguiEB/7eJEgqx1chnQv4cns6tmBBA/Ep+r1y40cMISeRCUF195UyajjhvIFApe6kmyxRR4yMZT+NaVkO22gmwKE7pXG4ubn16aPsMN4GRhra3bEehdTLoft8gerhkjJCtRlUdcVCc+mQk0BD5vOBOwnbo5Ch96Xok9v4zSHMmznudeKimaT8jH+aJOlZUEZoJV6IrmcC8PT/VmTeDj2mKrQMO/CU2pkORhg+ba8rXfPujnkiSfGqajLyEawsg5IyHKLxdyHK9r8EeVydj3pTMt/Jq2SdXmy006rkDoyfDfixhgtO8hB6FXfDclL62yc/T1OLKY+eBoy/SBmIDWBu7QgcohiDJl2YnGvxKUKk2jIRY8zQvj2KKNrB++7n0y6GpCDQNe1sxAVhT6k+97jRDUqcaZIrNy/eJ5vyZURv4+icHueGtVfv69KhTgo/vhXQmaG7oAfibmpciPF673OZMocKXthpiqwQsGf+So7PNUh8lSeB+sRZd/K74aRmb5oUawV6t7+hbJuCQPXc65jdhjI4hg/bk8BVmdPhAJHnFQP3pwr1y8fo54FufitelwvjHV2OzQKVOD7doW2JGZLm/nCpgPRQAX0C/VA6MooIaPkdgyjI9P/jl40157OkVq2OZqwxsi9FwDCSONUKj8YKJJpk6rBRO1iLUqlqK8P3VB6828JoV8yBWUFoMjAizlgUcrlpH9N6iB3Wau8n7dhMjgKgYd2OLlNjI8o9ac/GMHoItkBmHqISHXn//zo0Po/MO9jp7bEOc7AkR+v+FY+wosmIeFDZugWUpzL+rXsv5IgmLrf68fLSaJwXpCWsVBOI0IgaIADEbevfcUEbz6h5Hp/pJmivFhkQpNHQGZ8VSAUs2OhD1z8/CxlfPmVaQdK6xnZfpK4Yk/i/axU1z7r+LLyv
 BQxmHQny
 C9PI58dC/d3zC2ZOOW2wmhDPsqseZBsR0hc9Iq7iHfzeo5Lu1bjVll/x8ivSeQVvJ7TXXZui5iDgNqJLXZdujLzp3Mmbe8z4I6hcJvGdT5TIYalgHsnfnzkc+G4sHjavLfbOXYeiIMgb+NB2WYjKYIVuFqLMQu+T2vr96/QbkmSEQ9rhp4pAKCmfEbJLlW9FlTPuPB+jeNPAKQVYLnPt7tT9qmrbSyYL58zgJVWa/NUGlvEeYAXzBr1/04VJBUinWJtUPfGe1vKJMTIT5eRfKCgAtYxuyRoib0QqLICtVqaEw6zv6/rJDdUrkVFhDLCg9/VOloF6YXNQufYEAtGFzTZcNI38cOvVaAe/R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Dec 2, 2025 at 8:37 PM CET, Alice Ryhl wrote:

Applied to driver-core-testing, thanks!

> Alice Ryhl (46):
>       rust: auxiliary: add __rust_helper to helpers
>       rust: device: add __rust_helper to helpers
>       rust: dma: add __rust_helper to helpers
>       rust: io: add __rust_helper to helpers
>       rust: irq: add __rust_helper to helpers
>       rust: pci: add __rust_helper to helpers

        [ Consider latest helper additions. - Danilo ]

>       rust: platform: add __rust_helper to helpers
>       rust: property: add __rust_helper to helpers
>       rust: scatterlist: add __rust_helper to helpers

