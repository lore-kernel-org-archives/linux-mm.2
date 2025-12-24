Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A380DE776C0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 15:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135FF6B0095; Wed, 24 Dec 2025 10:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3E16B0096; Wed, 24 Dec 2025 10:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010576B0098; Wed, 24 Dec 2025 10:37:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E41A06B0095
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:37:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9777313A939
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:37:37 +0000 (UTC)
X-FDA: 84254769354.07.B57D118
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D04E31A001D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:37:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HU3PatpK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766590656; a=rsa-sha256;
	cv=none;
	b=WLmCmZlbZ4ORhEGQV/hOb3P9N6gqF/b8IGOXISwKtXsOCXFmP3j4p5X/hKKMvqKI39DEbg
	J1BHnNV9QRdeP/0W/4ePlt5kprin656IsbHtSX7B9Op56a+HkJX7VICjXIpBOFRpl5Qcix
	zHN+Egyw/o7PmPStmdXeFa2bNx/YrNY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HU3PatpK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766590655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzgCU8StrOtNIMWKsYNVDjtVlwixRxdTIZTf3PeMQDM=;
	b=bN5wH53dw/dSHIsfF2/I5jiyHKJ0qGOeSsRtjzamRYI3D6GjreBR2jTsOpjaS2hvMk0XOW
	D/8tHE6eofJJV7Q1AqBlVNHb2LLB+LqAe9+azm/KsQQ+kVandUEolq+mgOf+JIFZj6ZR+u
	tZ6XFHEv6VY3ysQd0sQmsdB9vYU7vjw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04D6A41E63;
	Wed, 24 Dec 2025 15:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B748EC4CEF7;
	Wed, 24 Dec 2025 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766590654;
	bh=Kq2IKIwGlEg3jCMrjcxejf8rYj77mjFHSMzj/fyqpVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HU3PatpKRIH9r9cf9LBg691ulT/Eg1MJt3PwpZ81oJMY10QzYmgdQmgCfr+YGB3zy
	 y6vB3BU9UbJqOz65JZBXcJRGqkGISFl6LNo0j4mTUZRqoOZqiPNrc3S2pCa8V0qoZ1
	 +2jZyqLxwO2guSPLJD2sTmD3wkg4gFWLd2L0VltOb/YocfwqpATjDiuqJEC16UnFJs
	 AigKEHXfgKcPIGA5EIKmFMkOMyzYaiQ6y21iDoQYof9nFeMtIBXwnaAGCHjwrerrtE
	 YP8jkDUUy3nANQP6xOmNAWYh8GTAjq9RVZfaDXQGaVZ8aptQKjQnCQQXhvkAgmBqbn
	 02ySujIllgAcw==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: damon: get memcg reference before access
Date: Wed, 24 Dec 2025 07:37:30 -0800
Message-ID: <20251224153731.69411-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <peusxpenpbjdnhr5nkgvqtiuuofmc6khsxsxxvj3k3eyledkft@kgvgid53zbbg>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D04E31A001D
X-Stat-Signature: p4xmhd7b8adermuozumxx1g5xcqx4uoa
X-Rspam-User: 
X-HE-Tag: 1766590655-155015
X-HE-Meta: U2FsdGVkX182LhZazOtQDy7NH4bF2Lfk7CzNMO+7VRg5g2K20YEWhciDC9i3DJjRVQPSN+6Vz5QBTpJeOORwuePVsbv+BgQyQDQjShyWKQSAhs5dVtBqTQdCEDnK3pMofxVXjwry87Be71XrsHAS6JLTCzVqUcD9PvOmrkwoeRryoTQlQ5pbWPLr0JmqlrrKG15BHMyzc56fr3nOly8lbjDNYH72y2VM3NW4wCLmgI2vIxM49puh4ZMtAMSyL7vFzdVDWPGOjDyBHxBvJn7KbfJ/bJsSpSG1qWJcRT7q6hMQeu7msfiNDpWe4Vl7bkrsKvt7DLx8C55xYi2en/mwxz+iWLMyKEvlq2HiDW9FWcnGTViiTur048o1DWYFukUE8rVnsor0P3OWtzaz+WKTxD4CHJvciGLZRw00MRT+Nmt8ed1SoD4Af//QO93QuoRfNx8xXd9q5rxnzoC3heHNDeW2TK5lJSkWidU1T143+oQRxDGcXM7wd88jK4DBOHhXlIl348X1h1GZjBkuESDT479GxhEhuoYMD6kX4oOk/IZd9xB7LaSE+XKXb5/rTmC4Atw+i/41+zwFBKe+I+dVu/rlmtiPveQZmpnEhBDrKruz3YB490AC/1h9EvFnn7r9Z9Ng1SQRbGLmO6qMjzfddRPe4YhANFw1/D3egv7yzQM5tjGLWf7WUhtkKvwdFp0vdDxTQWvUqIgUtLrQeUcUa2cxCUjop8oernucoPFCQaKYoD5qWgNRPiR+0xn6B4oxwmrnlscW4wI/0OWyXHsQMtjMV7ii5AjH+hQOupOcRhavaDohnBvutW2jo2cXQI2cveZpTkqiyeOGi78H24ftPNjknOt0UTdVMkRaQT5viN7c8lzg+j7heuDEI8igYTgw+EfOrcXcuY5RP0iby76ATqIbwJvAiThRiia+rbzPpSp0y5G4oHc6vL3H/PlT6OSM7xsMgt9QB+whC67K7KV
 IR9J4j2R
 0cRD4uKMFyu4cYOOhOgGWqTnfprAGFVBGvfaaqXPkYLmkET0OX8XIlu992tRi8jvtQpa22Z6INgQNC7eKzeg5i4hqM2B4iQy0XUD6scl6InUFCaii9aH3TA+rwqfftylAS7T4eeUQ+S7ReaOgMVgM1pR5Hib5tG0knozpof4jRydPXH1iq48h4fpf3kU9hOYtHTuctD8gzGhvjn4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 23:51:55 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Tue, Dec 23, 2025 at 09:21:47PM -0800, SeongJae Park wrote:
> > On Tue, 23 Dec 2025 19:45:27 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
[...]
> > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > index 4ad5f290d382..89982e0229f0 100644
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > > @@ -2051,13 +2051,15 @@ static unsigned long damos_get_node_memcg_used_bp(
> > >  
> > >  	rcu_read_lock();
> > >  	memcg = mem_cgroup_from_id(goal->memcg_id);
> > > -	rcu_read_unlock();
> > > -	if (!memcg) {
> > > +	if (!memcg || !mem_cgroup_tryget(memcg)) {
> > 
> > For this part, I was thinking '!memcg' part seems not technically needed
> > because mem_cgroup_tryget() does the check.  But I think that's just trivial,
> > so this also looks good to me.
> > 
> 
> Hmm !memcg check inside mem_cgroup_tryget() is a weird one. It makes
> mem_cgroup_tryget() to return true for NULL parameter. We can not use
> mem_cgroup_tryget() as is alone here.

Oh, you're right.  I should have read it more carefully.  Thank you for
enlightening me :)


Thanks,
SJ

[...]

