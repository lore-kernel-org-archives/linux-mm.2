Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66245F99C88
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 16:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384086B02C7; Sat, 18 Apr 2026 12:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30DB36B02C8; Sat, 18 Apr 2026 12:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6546B02C9; Sat, 18 Apr 2026 12:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 041756B02C7
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:15:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79179B9BC7
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:15:16 +0000 (UTC)
X-FDA: 84672176232.12.B15A082
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id DA119140006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:15:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=a9NCpFDe;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776528914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXjaVcU0HcKrPw7CYCyN4QEtiplgwntWJoRV59jKzzU=;
	b=rFNs3f7GYLecmivmzrrAqnVdFj8kh/m0zCcR9hf4MLjjW89GGLjpRoCU1i1X7X8oEmZKLw
	MWZySGrJW/Z2hQrWdfE6A5I+7KA0xVlJYabnCMmadcdvGWd0dk5FQBIU8H1RwTC6a+XXdk
	vWlfSuLNN6w8dgSEdQY4e8DLsZM2jVE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=a9NCpFDe;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776528914; a=rsa-sha256;
	cv=none;
	b=MKLZ8cHldppfFxwpcAQU++hxpD93cJghGL7m3TBSOdjEI5ZiP6v2vw3UD8imqOVqk5JClm
	ys77zp8fdJ/KkPjzKyQu58vcttj6rI7xdfhCVNjQAqSty5oSvnrXhgzK5LKllvyCeZ4TB9
	4zsdrmYylLaxLlvQRRlHgOED0JV+jYM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WXjaVcU0HcKrPw7CYCyN4QEtiplgwntWJoRV59jKzzU=; b=a9NCpFDeaYKGkdhDEuc6SmCNna
	n2RKJBv1X1Fs9p8AeOFyWTDTNn3PQYo4qn9pkRbkMVIc5LhX8tVU9AHwRk24yxmqyKeGk8L0eE+a4
	Y1DIKjkV/DdmS/+czfftl3HP7MxscyVw2Dx7oQ66kRK0N6Sk3hyHsz4KueHKeqgTdcZuEWtjbf4y6
	KVh1SLthde9VNGjWN2kkAhrgDB4Zj60yJJhLPC+EOrAD4+ZFRzgvEum7a6IRVGnryQosi3ZrTvLRs
	cA4BqscZscQ9Ylkn5KZyLyBQbTEBzp5GFsgLDHPdTThQE15tV1Q8mRN/VzjIZRg46QA6zEQfyF7q/
	ir031dDw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wE8K0-00000005jk3-3mIU;
	Sat, 18 Apr 2026 16:15:04 +0000
Date: Sat, 18 Apr 2026 17:15:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nick Huang <sef1548@gmail.com>, Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
Message-ID: <aeOuCH8ydw_yzdXZ@casper.infradead.org>
References: <20260418000635.17499-1-sef1548@gmail.com>
 <aeNGbNyPxJssnkbO@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeNGbNyPxJssnkbO@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DA119140006
X-Stat-Signature: fahho411uu3nwyjxzac8tfa8j7jf6kak
X-HE-Tag: 1776528913-218198
X-HE-Meta: U2FsdGVkX190HhHgkgeggKNBil12COztV2PUNH+RvqwehtUfZGJAcOhMu5hWgC7T5pJ7VA9egcZdiglPA9qRJ5NXNtkgnjY1kzs+9F5Fb4ehUqQA7KvhXo5EFNgLb6HsB525fJpxGGFa+C6kWpRH5qyr8hMKWq/vo80PmJe0nET7AEyAsgQTFjSHUY4FlAAdbAnO7Z9UPJiASc7INZeTuCsCIk4jdUK3mu4buPgGSdjQQs0d/kg1BMtk5a80uuSvBAuk7WEqt7YJ/lpqaeuBJoL+O63WZhu3UVwyP26PFPfv2REYdz/O8t9pVJEbs+iZMuws6mHXrYnIeACBmzeKDU1oWk6p4ZINub/sRFpWXgLKYUbGlKrC3aQfNQrwJtLpMLESAPadI4X/buGc3JnseFfLCon4PnCK/KLINaResyfiS8yX8i1rW4il0KSo5UWUOCIUnfagBhanbIo+znaVhvlEu/vHRjiQNtCjmzefoQ+IOwo/Om8sJjif/PcCTvjCYYy7cNnaHsdt7sp6maMlp6UHZNmUY//WOUPT1q2ywohMCQ6En8eQi20Q00y0HkfyNGhJgfwID927icPj7ds+Mw9YF/y7XZKhIqo6XKI7WShEgoALtfDWjzJwjbj1jD4D0Y5//Jp0H//REq5LEC/fK/OJUHIqhHaaAgBK+Efx6bBZapChXH2/6AHEAPR6/+Cdq78xiklfAQslHcBgLmupUIFIyPACk8znrGAalmOI2bVPIKq/ynsHWogk0xYbhkQaB5tB0T7zn80g9fgb7DudCXzk+HBqhXvNcazAXaphie9CmbMqBy6bbkpbK9XEHsosrQI352QNtCuJX+4oZz8x47Ty5ZiqmXTGO1iXyD3lU9I4+D/7JnNbE0nrwkjBrvNniggQZ0PjXQhh7fx+ocRxq0KhDHXAjUkpGoQHFEnPHX2DTYjEB/BPV5218UfBW0p4r6Sq6fc/iNNn6+NBEAX
 N/0ZjZML
 Lxzg644YHkzn+yZ3s7MESfYM0WppRrIURGuEhGWfzQekyf06+9vFZpEmwB0/dl/6RqXIKgEo5pbv/Cxq5y0OecUXVgk+Abr7im7uRxhVcQFkFObm16cNjQ80tPjEBjmK6rUBpMuuHXiGPhCc9uP03KzwhgHncAHPz43iO4aPCKof61FjlyId8KhzfGoOJRIkfTYBXl8yEJ2ksG8iTTPtTaHt+cV1Ew3bpfJhuyZ8fsWOxTEKgPVO0oiwL2BYBGI8574HJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 10:07:22AM +0100, Lorenzo Stoakes wrote:
> On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> > - Add "Overview" section explaining the slab allocator's role and purpose
> > - Document the three main slab allocator implementations (SLAB, SLUB, SLOB)
> 
> The fact you're insanely wrong about the current state of slab only makes this
> worse.

This is actually a new low.  We've always had to contend with people
putting up outdated or just wrong information on web pages, and there's
little we can do about it.  Witness all the outdated information about
THP that's based on code that's been deleted for over a decade.

But now we've got AI trained on all this wrong/ out of date information,
and, er, "enthusiasts" who are trying to change the correct information
in the kernel to match what the deluded AI "thinks" should be true.

Let that sink in.


