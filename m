Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9A9606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YeW1ivzy
Received: by kanga.kvack.org (Postfix)
	id 425CF6B05B1; Tue, 10 Nov 2026 22:08:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B03C6B05B2; Tue, 10 Nov 2026 22:08:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2782E6B05B3; Tue, 10 Nov 2026 22:08:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7CC96B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:08:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EA2780126
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:32 +0000 (UTC)
X-FDA: 85421355264.23.8B31EF5
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 64B7C180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YeW1ivzy;
	spf=pass (imf16.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794366510;
	b=iw5k3l9QpTQcvw2/7+FK36vfw7Qd7rbHIPOezFGBiTXFhjjP3KnGh+tlZk7pvRPx0WeVii
	Z6xV0mzKLW0YIglDTWhgeTzfJIJsecQK0f7Ihld1I7c0QqlG8UkpkEwkYl9JkBV3GrXC0x
	6BCWbDDkV6Z1v1okqkcGoQDuhCF9r3I=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YeW1ivzy;
	spf=pass (imf16.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794366510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWUQRFbmRLGQnDyBGsNebPidDTP9HqGva0/1QMumkOA=;
	b=VzggE/ySog/hM6ryd7u2R1G2JA/qyEjSuo7oX9k8FXM19iY0pJRhK8LesByVPJ8XpYbECD
	PKjwCgLhZVv1KANBMUjQmkKf+KPgQkqBhzpUtqapuK2Ps/30mRKX6SF6u3RieNn2oHWgOy
	QB/R2Pkl+SIwYgX2zG711MI+60hvNZM=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so33424295e9.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:08:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794366509; cv=none;
        d=google.com; s=arc-20260327;
        b=iOg14aT5rWYBQZBH0sSIuSRCFYxaZtyR9XJXvNwgrdhP77qIHBi+CAqkwT0i8xftXr
         YO63ZPZtZJ1LweUVflJeh+UTcMq9QApopfHOVQmlx257NrLoxJ2UoXYiefZNAEBSKE8D
         56OaxoiQnqOKxDHHusyFIG2nwP9zzx6MtlDNhzmfRF9/YdL3gIIGFR+1ppBEUS7YBmaM
         JjB2LmzXebQ6wuEHuIubWEjfL1L+ICtSB6vKywOdilwNN0GngqVq+6TrAxpaZzWXbhVG
         4dBqtoh/7G4d12s4kgrAIlsdwoYSaUujOiRizkQc2FxBsTHe12XmkKR8HlZ+ZxD54TqP
         pwvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UWUQRFbmRLGQnDyBGsNebPidDTP9HqGva0/1QMumkOA=;
        fh=YaQQuRfjasracu99KhaxcK59QZwfP/v32xMg9FS1L4s=;
        b=dKz+e/sjFm2ehgs036WxYJfJ03J4EX1Xa3eA/bAM1c+63iYKvePWVjT5idEHcCuFKl
         ZGjnAPDVSgz7kKAIWavJNvQDQVRQTyKZknbPJWBmO2lplqsu2k3Eyznt7ZkR+1ltzedu
         vGmnKVOvX42UMJG3WRzpYe856C0OWCCTGTVv0UOIK1NP+bcIhqWpd4/Qz7fsaidWkmWS
         sZ8BMxoDxNy80XriQTf6fXE44NdlQJHWBMvE9FcXlzOcM6NicQz4k7n0vTyZdkAWo8zH
         gaCGM+uj93+CeFYTjwEzER5OLldxp/uwCMGQg8HSPFzrALxftbpbsMX0gaLppTrbRaaF
         R53A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794366509; x=1794971309; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UWUQRFbmRLGQnDyBGsNebPidDTP9HqGva0/1QMumkOA=;
        b=YeW1ivzyaxXYxA+AoQ24sguSaBYfKupw2YE631RLf7XY2aoMVysPOTp9iKDL1St/qb
         5rJF5S4ceg27DFYiyLQXB3S8fJKp4Yds7DHVOyZwhibjD0YHnoUg98BHSppBRaSg/UF7
         kHoIL3TLkL3MusmrzoilAhGJXc8qkjuuF13PVh2YHIwrTdMuvx0sB3Ignx51I2eiQ6YI
         pmrgajoeLrKXuf4266hbfeehJ4hc0qeGoOBs21AYtVNkKkVxxftcaJGay0g8fqZwU/5q
         CR8f/DaVZFqA0NeFNDFFs4cCp2dYIdSw7ccHMYz76/j3Kdej/TjSZmhB0UYGTjKrD6nd
         PyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794366509; x=1794971309;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UWUQRFbmRLGQnDyBGsNebPidDTP9HqGva0/1QMumkOA=;
        b=roNnPzdazLvZbYMZkvG7yVfCoFajixPbe9AQ8ws8xtRMn2OyGY2ef/kR4a52c+CBFm
         7S6tngnrQ50ugHX+267xj0ks5I97rbywDkrUkAIR9iMysbo9WQxH5WjeU93L+O+Fzqci
         TyTvjhZR4T3wTBnINk22zMXDsI+IjEhZGXRRkVrXRqYRBmuHg4Dxzzpc4pIlgG2W600F
         mQ8Ilisf4Uci3qOVsUEUCzxzxMHuw+5Kd006RClQCCCY1buC/JXx7pNEo1hUs1irRhbe
         KiXd+Iorxf8Zou4rLtY2XvSqUo9L1e1By8J6WNYErnjBa7/4xTC5cpvmHXhql0X7ECj7
         3PeQ==
X-Forwarded-Encrypted: i=1; AL+hErEzUaCfoI/+4DRtWeplhpcLtnsqximHCp/IMPSOpWdXd3VTl1gOWEXT4Gg1ZozTxGgyK/joDqkd4Q==@kvack.org
X-Gm-Message-State: APuU4Z+WSBOjb0meVFZqiZGRuMmroCB3ZoYn7uV083H75y+X4MGRfJ8y
	Z/bUOa8PBQB8kxrf9RqQ+cxT/gyIraJncmvKBuK5XhMcTzK2IvSb6i7lG92hVSmwbdskNmn9Dxs
	66EQD67CjO+xvgAisJCn4dx72wLnuEck=
X-Gm-Gg: AYBFou13jDpDdoA0cP0tE2UhxtkEI/F5q8uwgapMRUHnVczOU9U4yL52n7f984Rgsdh
	g1prdT4uwwFxYbJdKkE82EDRpXbbMOribbB+24UHA+xMupqfNZDRNSjKpvuCawFMmXhaE1Vnbxf
	MGzsxQwN2wBFfMRNS87WmZjqBBjTTCpkH2bVbpMWiKm+Asj7DUreNHIxsDuCKuKLDPxi/t3EJ1R
	7N1IpW4BxZNuZ/Y/fMQMMfQfBY6LkPAHp23nOnXeXPZWzpBrXaRcTSu54AP28vO05XLY7cXhni+
	cuFTJn9rVKV1Eq+wipcvG26AJbxSh7Nr0JqpZqMDoO36unEfGU2D74N79rVaf+1wwTeJIUo6qYA
	XDw3NrM4dWlr40NtToX0HmmBHNvJX1/Lhw2/jHA==
X-Received: by 2002:a05:600c:3f06:b0:49e:6581:7baf with SMTP id
 5b1f17b1804b1-4ba0931ef17mr14337115e9.2.1794366508821; Tue, 10 Nov 2026
 19:08:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
 <20261108230842.3a77b9fe2d4bfc2a04b355a5@linux-foundation.org>
 <CAHKocdGWE9OVA5pJh33U-FYnNkUqRS0pzFt=rCwXWzY9w-QXyw@mail.gmail.com>
 <20261109140206.GY9176@e132581.arm.com> <20261109092404.5441d8bf9c4494ed008162fa@linux-foundation.org>
In-Reply-To: <20261109092404.5441d8bf9c4494ed008162fa@linux-foundation.org>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Wed, 11 Nov 2026 11:08:17 +0800
X-Gm-Features: AclHuK-m1Jv5Lpg8e2HNShd2BigzuuDvNRyTpoQSxJNGTZo8P3hgc34a2sG_LX0
Message-ID: <CAHKocdG1pvZfo=fxX9OJZxCOnZt6nBYwtRV7rAxPfdukDy6cCw@mail.gmail.com>
Subject: Re: [PATCH v12 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Leo Yan <leo.yan@arm.com>, catalin.marinas@arm.com, will@kernel.org, 
	urezki@gmail.com, linux-mm@kvack.org, baohua@kernel.org, dev.jain@arm.com, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, david@kernel.org, 
	rppt@kernel.org, xueyuan.chen21@gmail.com, chleroy@kernel.org, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, ajd@linux.ibm.com, 
	jiangwen6@xiaomi.com, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: e94w18id6kqmcgqf5mko5f5egig6nrtf
X-Rspamd-Queue-Id: 64B7C180004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794366510-355537
X-HE-Meta: U2FsdGVkX18Ho+Wsa802l7C2qMx1PvmsEEUzIoMGHPXie9ZCPpDFza7j3sxWUB9B1zVckUPXfUNKk7HwyrMUkFWoW8ibYC0XmiwJmadq7T/eIAuTBb7I1elpebI4RDvtJbV50XkZjBmUCArVIr7H8QYvOfELbeJ2kwGVTOK8VAdcb1c6iP28y6HGcREmWpXexSXTA/DO1Sit81VJ/WJdFLSCpesVU+8ktMkCK7Bq6fZ7NeD2mkqKNVhJ9LQzFHPSRBD7Ywqyx00lXfMbqFwoo/bBYDNVjqLZ13i2l1yBk4CLSsaMbZvpH7KVazEKgCuKY2AY9CWWDA3WQAts07SsyqLWwm/OuDuFBv1P3wo5Y8YZi6MXwYy5OzhJWfLEisxfDAWZ95ElvPKvxlKsAQmW9HhFbbxCKgo6rpT6WrYT0+JN1cKbcfLNwdv8bJYzqQ4M8ox8slgguWIa0MMSoM4K0Rqrfe/9W8feEI/dQlNDuobSxjr/bFV3IO/N3NhgDhNAV1tfWtdv2YguMkSWpHgYoS+PTHlUHn+Am8pd20NVzL1+Bwq86hB0VqTkTD2QBOOHH6LcP3L3j9nwC/I3VBrI/sCOsoCianjQMx1W6l0eCA2hpuGXKS2Hu6Ydvuv38CDZvUt5cipN3K8Ee8KvsDs4An8DeAFgaOO/iMlB048OP/83rJmbVSuSZjMXZroo9sC1sz1o3blmbcYI/Zdu2kkqrKOi2lmBy7Fyzm5oFzzJsgZcO3FCQwWkfc/pK9t+lFS1/bgGa6HIrjL4F+FTcEqiQfzVHqQ06wki/3YjQXooI5XCbmZ/fFz1k6h+ej/k+qczhaSQ+Y100vlBytjL62ZG2dZzAp46qxrRQdgBaO59MgdRpYPyxWRhF1queW4K/fPUBQwyVvIuKpo0uYMTehu7LCDlwAki/IV7eBVI60/4gFyrqwbSbWBwvzSSPWm/QDV7MeThlhUPqf3/kTR0BMM
 L6m3+8HI
 ZTrA/CoYay+TahybkCsjG3ec8L2Kc/NjSsOQZlAE5x7hF4bUBP4ycuiZa1zaHp3dVdzD4uHStyAIIu8QKPCm5LrEtfvlpNkEUKYgRY50weYPxNRXAtu/IhC4TaMXunuiHPjuEOIsGTSgT3ybsypfkoOuN5iZDZm2OBbHX24gIwH2WD+bEoNIubglF9QmpqmYgG0wdzIzuZOx8yvBYYU1TAMPIPilNp0ibMDZWbPgAAFczctl1rulju2mxr+HxMuFv74KxpVI+fmV34VBVKgpem7nZqJjJjUBQeibfNipeLJmCAJ8+zPg99NtagKeuXMqRHfdrR9QLTrPEZQl7Tzso/cq2mdj7/x3DlYfH2xIn1yAt1beYcxoQYK7A19vTR5YVoHuO5QVv/zutkKW+ZrjzOHSix6iH1J80UNGRlZ0FcD++p22B5/ehMUSTNk79YvRDFpxueBxYQIOh2BQ6gdpeYUkKuZf9aEbMKzxifzoBf54+5xKqKuvPVias1TZxR9zxEfTTVs+FpaRP8hFZbscz63WShngIinpTVyKE44pKGgvG8Vdt/gL7koSLITXLR1YR++5e4+BZXZVb6acK7rEufGm7Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 at 01:24, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 9 Nov 2026 14:02:06 +0000 Leo Yan <leo.yan@arm.com> wrote:
>
> > On Mon, Nov 09, 2026 at 07:07:23PM +0800, Wen Jiang wrote:
> >
> > [...]
> >
> > > > Do we have sufficient ARM review?
> > > >
> > >
> > > Thanks for picking this up.
> > >
> > > On ARM review: Dev reviewed the earlier revision in detail and
> > > his suggestions are folded in. Leo Yan tested the large vmap() path
> > > on TRBE/SPE. We'd welcome more ARM review from Ryan, Catalin
> > > and others.
> >
> > I confirmed that my Tested-by tag remains valid on the latest version.
> > The improvement is consistent with L2D TLB refill reduced from
> > ~16000+ to ~500+ across multiple runs.
>
> Thanks.  I added your t-b to every patch in the mm.git copy of this
> series.
>
>
> AI review found a couple of little things:
>
> : In [07/10], vmap_pages_range_noflush_walk() uses an int nr
> : index, now shared by the high-order mapping path. The previous
> : high-order path used unsigned int i, nr. Beyond INT_MAX base
> : pages the new index overflows and pages[*nr] can go out of
> : bounds. On x86-64/4K that means an allocation above 8 TiB,
> : within the vmalloc VA window but requiring a very large machine.
> : Please carry unsigned long or size_t through the direct walker.
>
> The vmap(8TB) limit is already well known, not sure that we plan to do
> anything about it(?).  But the patchset seems to drop that limit to 4TB
> for higher-order pages, which can't be a good thing.
>

Right. I've posted a fixup for [07/10] in reply to that patch, switching the
index to unsigned long.

> : In [09/10], nr_contig < 2 can be dropped: the loop guarantees
> : at least one page, and vm_shift(..., PAGE_SIZE) returns zero
> : for a single page. I withdraw my earlier NULL-page objection;
> : I could not establish a legitimate producer of that input.
>

The nr_contig < 2 check is redundant, as noted. It's just a cheap
early exit for the single-page case, so I'd lean towards keeping it,

Thanks,
Wen

