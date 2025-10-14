Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FB8CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103338E0105; Tue, 14 Oct 2025 09:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA9A8E00DF; Tue, 14 Oct 2025 09:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B988E0105; Tue, 14 Oct 2025 09:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA6548E00DF
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:31:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 854FE47694
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:31:37 +0000 (UTC)
X-FDA: 83996807034.08.A1A3DA9
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7BB5080011
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:31:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SDDU+afx;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760448695;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRUz1hWdNpegFSxtg102ODjrrEjXcJrCzI5fyTVJ/6Q=;
	b=2mHIHJfuFvKwwDV/FHNASLbgX5+q1sFFxm+5kLgL01hLpsiUXNHQ2qXSMVZ0HA641ZVweC
	iIee1dRfg/rU1QPU4Uzmw/Xwuf22zYXXH+gw2gEgAdFXA9/97rYKyyBOn8CIUJvpl83AhO
	0Btftc1ei6P3OG9lBTWuCjfHeLlyYek=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SDDU+afx;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760448695; a=rsa-sha256;
	cv=none;
	b=H4jyq6Ch0nZH+gPaf/1uKMPtNmcAEj/+/JX0qvVY+2v4RnwXj+d7bzQCQ9rf+mWDsDcw+6
	dkATUm2qoJ1TBEhKLFF6xRQsZ/sBziRSWDYf+2NKXCzSRRK4Sha/ukbwK/h3DX78be68SG
	OPFxvEy8/SPspnJuDX+n8u8DrbHZ41g=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6318855a83fso12121175a12.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760448694; x=1761053494; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRUz1hWdNpegFSxtg102ODjrrEjXcJrCzI5fyTVJ/6Q=;
        b=SDDU+afxw2VcQwKVHVeXFr7XmgRM3dxyJJwf8VbD+XSmUUBBHP3pCUm3tLi3yxwmYl
         V7KYyZBF2l4Tbr8RyG+Di0NrIWa3UGwwMWy17mxsfO0LEF686jqQHO9JRhMCHYJjfcxN
         tkHGhrf/mNGEJqBX5nVo6W+M43jbTxf0QOpSsdt9AnhdJJPg+enTAi+hbf3Rq/X/B+J+
         qlxChWCwo0G+zMs/0xtZ1KcLZBvcym406ySEUTNj9YtlwUz+P5kRVY3UhL8GdVpcv1eN
         KtKpGSfApR3mT1G6DXGvFOIIi+jAPyPkW/eCdzOjrJ852M+MnN7M5CX3lglJ2ytiGDZZ
         M/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760448694; x=1761053494;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JRUz1hWdNpegFSxtg102ODjrrEjXcJrCzI5fyTVJ/6Q=;
        b=OS0ks8aFumFPMDkPnoFEz+2gAQD/CqfySeoEwjclB8TZROL5bcKMVawpJgnKYdgt5x
         /lFtFl87BsPQtOlHgKDx5IyNZjrtPT1zoF3/ytGiztmsQgGfVgfeUIvn5TsrF+bugGTh
         lmYr8e7JzkTts75zrRReNuAvR7hbzVTFuuL45kiAEkcmFZNWx+js2f67Y7qsIt65WSG6
         ThMuoHzKuV1zAq+6ICf5hklN+EscQcpQtT8lk5tKiRYYPBKvRoCspya7WbMnssmLHyhp
         EU/jy6Lg168a7+IBKFMYCFhh9WPlvZm5RLh7wvaqym2i1dKEe9Xg/97RU6uwOKUN3mFN
         TEjg==
X-Forwarded-Encrypted: i=1; AJvYcCUy7EL/4A0f2fqxmF9I9uFay6Js991sSqJ8a7sq0QPRNXGHeheQcMMqeK0MhDWb9QEYPhaGtg83Rg==@kvack.org
X-Gm-Message-State: AOJu0YzwRylJ4Sr39OgAvRwOsovt01HOBrs7Z7/uFz8oFVgvxNUsiBHT
	2rwfRcxLJBVux4Q+04LVmEYJDGC4DRnroryMgOUB4MgR8G8WbzdL0Gxt
X-Gm-Gg: ASbGncvZnNqb9IsS/B+1dQz376Kf0u5OEnEWPXG+UA0DbWqh87bgbwV3Kd6fsCZmE/F
	P3dtaD+HonjI42HPD3l4jIrsOU6Lo76gfb4c9LtOzt0IKt3OZ7I6FTwkKLTvIKn8S2H+IiHmx3t
	bjLqMRJGQRKC0bY1MXoWK9JNy7VHGC3vtMQN01spoUfcetwEAKiHIT5h3QlKJUAbKNW5CUBLs5P
	PqREs1FSxGRUeqMa7y4eMxdruvwgIFoc/YR0f1nzAQi4Ww5TeBvK3CWUQekugV1mOoMOEYdiFvT
	kmvXRiWVY8G38cul7H9giI2/bHo+WEZ2IXWIClZet8XWViA39pxJibVTkjBDcPHeePocI3a9ZIp
	rvOUDCd3SWsxuSqC+QiyLFa1cD/n35sCa+IqIvFsalnOPGPExrjA=
X-Google-Smtp-Source: AGHT+IEgU+DdjYJjvofvtunCeX3nSH0eRUv1dqIRtOgeOUMEIzSuMU2hUdZtSc3ZGyXswVn9RHzZCQ==
X-Received: by 2002:a17:907:7f0b:b0:b46:31be:e8fe with SMTP id a640c23a62f3a-b50aa48c4f0mr2728492866b.11.1760448693406;
        Tue, 14 Oct 2025 06:31:33 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d971ec69sm1123110766b.85.2025.10.14.06.31.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Oct 2025 06:31:32 -0700 (PDT)
Date: Tue, 14 Oct 2025 13:31:32 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Muchun Song <muchun.song@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 20/20] mm: stop maintaining the per-page mapcount of
 large folios (CONFIG_NO_PAGE_MAPCOUNT)
Message-ID: <20251014133132.6garfzi24xlh3jr5@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250303163014.1128035-1-david@redhat.com>
 <20250303163014.1128035-21-david@redhat.com>
 <20251014122335.dpyk5advbkioojnm@master>
 <71380b43-c23c-42b5-8aab-f158bb37bc75@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71380b43-c23c-42b5-8aab-f158bb37bc75@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 7BB5080011
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: p4sst1jc746rqgup56x71ct99hfyw7me
X-HE-Tag: 1760448695-117237
X-HE-Meta: U2FsdGVkX19fDPH2lxVJvMX+OJ6K3wHxvC1av7FG/I86JXyn3ShwSzI5PJ2Gjmxa3qvhAaX+nF+xQ/2BiEzQ/O8vuMTHhAKH9n90Bm2LLXiQZ31DvG4poVvpXE5bMo5RW/3O7wQTwsKadlDyDMUoqZwQIE8QcBeAbkGh/tIdStpB6+R/ZP7xk+ZXzFW9S0/NTuYzikKFhUE8Puk4SVR7VIadnW2ENoSlslkRJlg1UUBYsOZTJFsfefoYbSgRnpTIQWb0igBInK39sTm8v6erhAdyDhqpPnGpo4TVPpS3syUP47OvgdLKIbhWrv4JWzvklChl0LSsQlJe3HbUySFKKKd2ZVPMgPoX6S7uGgcGuj7CTjLgurSd3WDIP0Z+/d4W83apNFy30g14/Sv3/ZgpCKVIZ7kv/RN5/x2MjEwBaitoiG0GW5mQrOmOeTJY2tiJxn95TDL+IZAmDvWIshwutmA+jJh0sxU9O7W1WTZiALU5Jii11gdfYxbXfvrfaEH+qO0muKysb/r77nJxA6DBPr6DQU3/uJyVjlgobrUFl/fiGksZhWb5KOi0IAl1w49S3ff0XrECXIifgR5CPHE/MqGb9b38mp6yDoGsCE7/6VEyEo6balaCtxWHZVdhYZj7e+T+msurcgfjOdlTk+EdCvTOjNLfJYvLN0+bWWQrk6LIYJCBrKnvTQ4IuglMM2ErURsPegrjbCm6+oWKnCOJNTkSmHp1XYT7DE12cptdMX7ofQF7PIvxPPQZBJoG14Hz/kJQYOdgwH1tuD1U14PaIooPzyJwwy9Vl9CrCfCeRE+faUEUGiTax2sCIAjBafkOqAj9hP4oGTE8PcxoO0GQUUGE3qTlhQap6DjufJf6SCeRAcAlGtqLr0N/ojZE2yw1kmy+1EyH8Hz7YaAT3H5Mmv3y5JEVdNXRXEhkfNlTw8lDA7wwcXPiMElq5vpVwC9YEw1dKL38JPeMzBWZSGZ
 iAxYg0bi
 Dtgk6/hvUA8hGrE9gh2+U8uE+uZhSxJjsM5MeYdiYGhwd5X3OkgVGDvWx3ud5swQdkcJDG1rhOerOobvk5ovROjd4eN/3irkZ0E2pQDzjKnyyJQx+AluAd1lgKIlinclDE92pIqpi7sGOxTo6t7wn2bIun7p/lum6Z9Ht8ujZFHocF0mHCP6LElfKQU3swcXbf9b8LgrBnvHoIF62wPjpIWIZd7l+GYgJlwCj/3DOlcyXrHtlb2/zmCcZ8ufCj+vni8HFgdo8fWCxPB7v7p52ioL8BJ9JRv8VldK8BU/IJLwJQxpeCWFkMm8VDMUZ8Xw0Rxiyk9O9dzpff2h3gfX141r28xRmfvv3zphqKfcdvG80Mcpibnf5aHZC0XaOnWxFEJ9DqpNVbe1+4CVVGmG4fdLDRNwtOCfE/owGD3tY625a41pOqBYBlwBNPUzpp3gcSUsMiw06M1tXAT0y3GZrJTZsfsAirDYKRAk5DtSu5zvNc82hYYRxuwiOuHCeDUUKMbLAjiV9L6Sa48sscg30qpUH+vb+uPcffxd2QONtyfr5Jm5cZxfP0PxrjKF89qfQfwzU3hidChfgRnf7FBlZe8AeXfPc0sLANkx88IgeWMEACJqPhoRsG9YXtj7Eu26W4WPz6BSouaQu9yMvXRiAIfgy8Cp4eKALrxVmFYdnjA0Zczvu81d9mCgahY15h5dKd1/HqXCSnV6wp/3oRDrf9I1KXVyvV2TgVdnG7j2gv0OGaUDnHpgWnpKx46rdcj/Abcgf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 02:59:30PM +0200, David Hildenbrand wrote:
>On 14.10.25 14:23, Wei Yang wrote:
>> On Mon, Mar 03, 2025 at 05:30:13PM +0100, David Hildenbrand wrote:
>> [...]
>> > @@ -1678,6 +1726,22 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
>> > 		break;
>> > 	case RMAP_LEVEL_PMD:
>> > 	case RMAP_LEVEL_PUD:
>> > +		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
>> > +			last = atomic_add_negative(-1, &folio->_entire_mapcount);
>> > +			if (level == RMAP_LEVEL_PMD && last)
>> > +				nr_pmdmapped = folio_large_nr_pages(folio);
>> > +			nr = folio_dec_return_large_mapcount(folio, vma);
>> > +			if (!nr) {
>> > +				/* Now completely unmapped. */
>> > +				nr = folio_large_nr_pages(folio);
>> > +			} else {
>> > +				partially_mapped = last &&
>> > +						   nr < folio_large_nr_pages(folio);
>> 
>> Hi, David
>
>Hi!
>
>> 
>> Do you think this is better to be?
>> 
>> 	partially_mapped = last && nr < nr_pmdmapped;
>
>I see what you mean, it would be similar to the CONFIG_PAGE_MAPCOUNT case
>below.
>
>But probably it could then be
>
>	partially_mapped = nr < nr_pmdmapped;
>
>because nr_pmdmapped is only set when "last = true".
>
>I'm not sure if there is a good reason to change it at this point though.
>Smells like a micro-optimization for PUD, which we probably shouldn't worry
>about.
>
>> 
>> As commit 349994cf61e6 mentioned, we don't support partially mapped PUD-sized
>> folio yet.
>
>We do support partially mapped PUD-sized folios I think, but not anonymous
>PUD-sized folios.
>
>So consequently the partially_mapped variable will never really be used later
>on, because the folio_test_anon() will never hit in the PUD case.
>

Ok, folio_test_anon() takes care of it. We won't add it to defer list by
accident.

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

