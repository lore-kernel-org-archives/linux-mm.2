Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56E97E9D404
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 15:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2876B009E; Wed,  4 Feb 2026 10:44:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C176B00A0; Wed,  4 Feb 2026 10:44:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A994D6B00A2; Wed,  4 Feb 2026 10:44:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9882F6B009E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:44:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FFE8892F7
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:44:34 +0000 (UTC)
X-FDA: 84407196468.06.40834BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7363420013
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:44:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBr30LtE;
	spf=pass (imf03.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770219872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=86TOPhED2LK9Z5gdyG52xDP8a9cxJnHCpI+YykKGTIE=;
	b=G34ne1J29eKqweTep+SVDfXG0ARueG4f51WQe4e7gdnY91boYrm5yCW0LNUEZIB9wzthCH
	hf75kGqhtqA0rIAbiRM2qnzy8q7zE7AUjgAtE7Vg6vCaz3eVQqMfLQSrl/oZaJYgB/6+vF
	UHHYpyExmdYDh/Lq9U2hgWoVN616/5g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBr30LtE;
	spf=pass (imf03.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770219872; a=rsa-sha256;
	cv=none;
	b=C+2nFTBXbKn3IaA8PQxPc6mAfT6cRpE+j+s7mfcF/+O1R+6h7K8pUjLUgWEU83Cwz8FgQT
	3Dv1mrkzXz+dCIapoK/WayWHEZMZRP4KUR4LCboJynf31R3ePVAoZrq2a6Nen0zQKrYa80
	FLyJb7PBnNrEj4iKv8VaO8PFg4l5AqM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 24AE5443AD;
	Wed,  4 Feb 2026 15:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71BCC19423;
	Wed,  4 Feb 2026 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770219871;
	bh=njzWuPzbKHbXrfvanK0wErBQpb7HTe1NuBwa0DB/VnE=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=DBr30LtEKnTojuKd7J1+fpgB+sbccKg9qCkTMMfwmwnq8KmSDDxmP+pEarvhEJsxF
	 4aOqerP5AamsMRT9hI0Vzv6vH+vi5F3ZyX5srZxI2hCyjD1S1PRxLHcXZAg4ggJbb2
	 Z4oP7qSLGK/MHR6MdkIzg2lLAtdKa7KFCDyV9CdUiwAKvzwcEorKFMM7sglBSGaOFn
	 C3fOfugbRFTfc7dfwzcco/zUMsDB//fQ5F94TmWaMljS2LOJdHma7aoEFpO/yoAAa2
	 eca60dsaJrUqZBkbSEX0Jgqon4yINjzlrxMJzftFBp13rS+9OqoHdfkMlcmZmgEOOL
	 6sbUZCVA836aw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Feb 2026 16:44:21 +0100
Message-Id: <DG6AKHUKXNO8.SS3EJRUSQO1A@kernel.org>
Subject: Re: [PATCH v14 2/9] rust: rename `AlwaysRefCounted` to
 `RefCounted`.
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Dave Ertman"
 <david.m.ertman@intel.com>, "Ira Weiny" <ira.weiny@intel.com>, "Leon
 Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Serge
 Hallyn" <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "David Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Igor Korotin"
 <igor.korotin.linux@gmail.com>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Viresh Kumar" <vireshk@kernel.org>, "Nishanth Menon" <nm@ti.com>, "Stephen
 Boyd" <sboyd@kernel.org>, "Bjorn Helgaas" <bhelgaas@google.com>,
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 <linux-kernel@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-block@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
 <linux-pci@vger.kernel.org>, "Oliver Mangold" <oliver.mangold@pm.me>
To: "Andreas Hindborg" <a.hindborg@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
 <20260204-unique-ref-v14-2-17cb29ebacbb@kernel.org>
In-Reply-To: <20260204-unique-ref-v14-2-17cb29ebacbb@kernel.org>
X-Stat-Signature: wn1jrpukw96gx8t8g35t6fgytwtk94s1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7363420013
X-HE-Tag: 1770219872-329976
X-HE-Meta: U2FsdGVkX1/eYbkrYS8KGcDC+DiD9YuUC8MLAq6latj4PWYLkf7oFyHpMUJZJ6LpYn0sMi+iOoyCkFvUcMClSIwhlvimsZeLCEJErSItSrwWHAi2GWAOpSi9ZcqaStbLWL6S8PYLYwRYjTYYMnnxxayuOB0drPHT+o7MLQK3joO6MP8o6ukWupye5UUTgt9wSGNlotH/5LTe0w607a4I7ScbW0gbdoveV7CYFYBHJEfzmmolY0S2EWSAHcunjpkdkEuoAj6NqI+pxE1JhvE25zZbcqZs5oyTuIhhFRYYfhTV1cAfSZ2P+zjhbKmrTCE33TMyMyo/AFfHdTIJLrocDErEuefDlvaI7uIZQG1qx7Eg82Ymie1TJNj8eHUNwtKNb7PpaIJeAkGgQm53J3pojbjbBnPrYposgBEWWc+Z1MBq5pAWN2bsyAXkM1ICD3R6uX+qKcLYmVOswsjYsiHzjTBrKLm6DAYNckgnIDOEr60QSbpIt2AKUooDaTwIP9crBQwk7iQTCsNzWfuuaYv+ova8qT7pEVEivJ5SHhWE+96qTPjmQysDNmWE4cQhDltnORJuywTv3WkQOLHiQzl3+jwvPai0deiwjm0HeGMYwxE2c5uKEswoOaXkxlecUlDocOtttP9U/gC00gB1NjVSut3CtVLF6lfATFZzubKm43tKQh7w77WTTxEpT15n+lLmMzZ29L1GlOOZpftiuHCPhy9HnrT1Tqy5ICVUl2OE0rW0uxHDbo0VkkSTPDxqDGlktQm+Q00fZsauct5861Th1Q9w9dRdFJfy4cWGGfptCGqvEIU6xKfx6vGM39e7O8s3FvinwcKiutKbhIs3qIvt7Dbs+q9Y4cS5D0WJ+ApzsAIIZb28JdgVqtlL8Q+lWCecIOnhyTL/A0DFN5Czb9Od3JF8pPbeGKKO/fLBlrZGwfrVrdq5UojSt2VtirYqYNpm7Lve3got2/911Sun2Vg
 3SH7Xcx9
 OG0BdNEeWWwiw8ZVLD65E7sR0ZRHg3JUVmOdCQhUH7oPd+ZuFQXttxt14xA0AwclEIFJvmPccxBfpdmtumnbQrzszUve/ooJm5rV+HeVSfBTW08mnVozbUkok41CmIcFLkXlMAdsC9e+SlotM5lQndLDPfl8rRtzd2bYrJjhwxbYtR9DV9ps3jNlhFOEwgwVc4hEU+k4DBAQgt7crm0mI3MdfflFv8O1YJR5x/1OhpmKr7pzyg3HABfP5F6ZhWtJHOMAwO3ZEhDd8VORVP0jC5nwtpWviTza1S135zGnStMyhId81ifiV3hJEFOnjJ5DVPQp96zAcbKiZI9XI5cofaF0U61lZKjszQnN50hb7O5rxYHcILHr955noow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Feb 4, 2026 at 12:56 PM CET, Andreas Hindborg wrote:
>  rust/kernel/auxiliary.rs        |  7 +++++-
>  rust/kernel/device.rs           | 10 ++++++---
>  rust/kernel/device/property.rs  |  7 +++++-
>  rust/kernel/drm/device.rs       | 10 ++++++---
>  rust/kernel/drm/gem/mod.rs      |  8 ++++---
>  rust/kernel/pci.rs              | 10 ++++++++-
>  rust/kernel/platform.rs         |  7 +++++-

If you apply the kernel import style, those are

Acked-by: Danilo Krummrich <dakr@kernel.org>

However, I wonder if we want aref::* in the prelude instead.

