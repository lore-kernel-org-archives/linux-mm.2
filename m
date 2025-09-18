Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 180EBCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 07:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7049A8E00C6; Thu, 18 Sep 2025 03:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC968E0093; Thu, 18 Sep 2025 03:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618D58E00C6; Thu, 18 Sep 2025 03:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53BA08E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:29:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DABA25ACC6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:29:32 +0000 (UTC)
X-FDA: 83901545784.15.DFF223F
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E6491A0002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:29:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DRQsYu5N;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758180571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TeUhfPwflpH8IcvEZqVCAI1Ffw6zpYGf0YbylPJd+s=;
	b=M6rkwjA/FgpXS/0zvoNqRc+IzcCJhlFCnvXCr+4d36+P5QvQgVBDB50Bp+LA7H3me2u7HN
	YMllQ//dtzA2f675x3Ial0JImZPvT7zqDloJhbxBR4qZPcs5xnXQOPmD6Qncq+v5SgNDuP
	ZvfjZ/pPF/bKW7bIvaqBcNwNx+gyhH0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DRQsYu5N;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758180571; a=rsa-sha256;
	cv=none;
	b=OCvH4n5ZfKH3UfI73/ooqLbRieRNM/ZxvV6dYmz0rVow1LcNpkqGBVYHcK2NJTFNBg8m/y
	GO44j6TpkZyg3tSjoXfVfZ0i+YnXI/OtvO16C92ljSZk2347ffRmpUWEauS2y9i8exHmnP
	Hi12rmsYyQ7zOKexj+aCmVeTF/5LCtQ=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b07c081660aso108712666b.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758180569; x=1758785369; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4TeUhfPwflpH8IcvEZqVCAI1Ffw6zpYGf0YbylPJd+s=;
        b=DRQsYu5N5AKx7GVLhx6X03qDZPESxy8lr+MtTpyV2xp4IlOTWNjCC9aCTUBtPRDSPL
         ymjeAF2OADn5yoRYF6XCGghD9xV12+np2FftrRwVn7ZLwYnsbsXxuSwgx1ANGAkk4xHx
         Z744w8YPnzzIq1tT3fDvd1rbRi1Zl9hWCpEpBHiDxijC1ss1LSbJ53gv79NuRpMMtOXs
         0l5JxQ9Zcm8U1FsRRwfOpu08QHMAUShjL+K4EOmVmoqcB5fQAHmCRV+2FBd99sx7xj1f
         RDbZXZ6+5etwe+tR4LGad2f3cyjHPgfR6eEk7v5ZIxgcnDzUPeYuW6cVdKTMVJtuOCcb
         0cNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758180569; x=1758785369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4TeUhfPwflpH8IcvEZqVCAI1Ffw6zpYGf0YbylPJd+s=;
        b=Xxru9RFwT9gJ8nyWfnFNkXo3g08dhSl/84kXpFSLRMBoIApbxhZQyB7RDnkQxuddav
         kZu4MOLQgPXXv7nSbzKmcLW9KJRDH9WzIVSt5jdmlFffvWUQBz2gmduD9bsH7hBi+Pl6
         6kcbqRNsR2ufQUzbHd+8MtatGzKZOLQe5Y0Fg8daj1ZEdbFOE29JcWgcElFFR2pGgvv6
         hQD+b/hoFYYiEhryhp4KFPdKzdd24Ml9XC6rANGzLjcR5+0spz/ouHMfRQZKk++YWpPY
         GZcPDkpenF0/qLn0TYhs6EN4RPAMI7BeMk8C97/vG8uEVuNtH/5O/8CqEUF1t86Ab+8c
         L69g==
X-Forwarded-Encrypted: i=1; AJvYcCU4yOuiziptqX5NKjIz4ixS0wxreFf61Fagk+jOXp/o5gUcIPXaLgjJivAt9uweYI4w1kJ80RZ/Eg==@kvack.org
X-Gm-Message-State: AOJu0Yw93QF57+CTAoenl85E5/Ytcpb/TZoJ6PFpy3J4z6IgTHBMpJ4z
	UjHVXWLkxt2tWVegB6Nu1FExtrOL+9JWuGjs5qdVedVFcztf1tIrbLhCj50Fu6na1xo=
X-Gm-Gg: ASbGncuoSZl0+mFodcDixLtnQA0M4kskf3LbxQzkPNQ20+EPgGGAFXlhuiTwa144x2+
	ORNMWZGZg/8/qs20iOvnVSw+i8KD61StuTaeg3xGsYcQzUij6OQo+iQ9MF3Zhc8cqwx6plZDUjy
	HHwY+ahBn29RlDbwNtjPnUndLAJ0T0kXcAoJoRbOurqWZFxZ2Qc19ht9NE6b5M5xj3TzhGvcrOO
	3fHakytlTVah90pQRx6aKj1UxiYN+D9NTER0giCAxMX05uwUmIg+RqHq2nJSgKfjisuPDgOCP03
	JGcVQ3jVVWC+Kqn2k2ehtfibqFd1qsZpjD2ol41JiguxeZkScMalWJMDrepyWb2sftMHfoUTVby
	SZCMIwZcGaSOG9YJlNv/Mks1PzNFoCbD8ESgseb3fzmEJFO3RGzFw
X-Google-Smtp-Source: AGHT+IFBM4C92jB9g5WYIgyFSfK4VqX6ptPMI+JV4FUWTBO8gbXhFHISPMW3943ATw/hCv+jIjxXgA==
X-Received: by 2002:a17:907:7e93:b0:b04:392e:7168 with SMTP id a640c23a62f3a-b1bbd3a6724mr532626766b.42.1758180569540;
        Thu, 18 Sep 2025 00:29:29 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b1fc74af9d6sm135689666b.33.2025.09.18.00.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 00:29:28 -0700 (PDT)
Date: Thu, 18 Sep 2025 09:29:27 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Ye Liu <liuye@kylinos.cn>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: add header line to /proc/buddyinfo output
Message-ID: <aMu01xIkj-3hgW88@tiehlicka>
References: <20250918071741.526280-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918071741.526280-1-ye.liu@linux.dev>
X-Stat-Signature: bob3iepgqmskjma165x6c15ewc1eoo3u
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E6491A0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758180570-27432
X-HE-Meta: U2FsdGVkX1/akRKi3SEdS1PgPB0afeey8NDWL9ZZHPB4v2Zx44CaNIFwjsDZrSrEumLjipmfxeG1/iO+FaGb2ah8aiA4gxlKGHdQRmXi7gGiZIcomFy/SkDDxQ7ohbG7m1Ub0gsCTB/gqvllqtAEqhtJJpxtF84qALFGRf+gsMuatyJbL/EF3EcoyXV6GmXyfYShDsA73xILbHM34BgjdTf1bMa2xh/R8X1nG8gGCbIKAlHhnlNugFVrrvhCI8YJ5/JhScC5NJPqVy9C7zk4XStdGmJbWbCsD3gnAXQgRs0UxLvOllh8CJkWDcwLSNPJ4m8n8DcgXN+Y1GJ7dsTlfip24nqlTSdoLzd4xpkvXBMPC96R5hH7cZw5A0NgJqhWpCUniGF45CxRXI7uObmw1LRzxbOlz7OjvfvhO85OsL93+7jRl4EN+vvPc2fFEzUTEv/VIruyhnJR4PtVugzXd9GXSdUb4VJgWLD67wSxCacSYuSD2sNk4FwqlWQMK2Te/JugmN9A8EE8APAA1/zzp8afHKmfrbVs3geOwauqn2jb0eEnhTUKITvwuWHyM4702PBDq8HtLp/jTzT9I/82YHNYv9mIbcaF0eKxjAdOlDycPWR39Yp41CspJrE82zK8pZ+i/MNCtoiyCXEyD6ieApKi9j163+HfCYfCjYsTiIQ+mq59Gd/6cxC8kCsr3vj171AWUNePx7ozZ723BZpsSKgrpuWJaqthlzGjzfIJOvNVmJ4meDdAKfFPdEuTdRJjCEfiD9glODexunsvg3vjMsN55cEvjRaPdcDedjh7/wFZ0mnRRCGuCLwiyrbFn+FAQZMX2tkUcnL3kucQjnb695cc+LD4TL4D6+LDBrLLNhV2W9sDoWBFd32L8f4xsbbV2z+yMnFKNxWewyzkWgz72CHhy+ClUbDHZfKRdTM8oK8mTq4h627uQkp9UVLCxgyBRapcYBrc/JGPe+xGEcH
 0Ii0xzau
 qmHj4ZT9Ab4QAP9Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 18-09-25 15:17:40, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Add a header line to /proc/buddyinfo that shows the order numbers
> for better readability and clarity.
> 
> Before:
> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
> 
> After:
> Free pages per order       0      1      2      3      4      5      6 ...
> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...

Why is this needed? And have you considered tha this might break
existing parsers of the file?

> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmstat.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index bb09c032eecf..e9606457ab91 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1574,7 +1574,14 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
>   */
>  static int frag_show(struct seq_file *m, void *arg)
>  {
> +	int order;
>  	pg_data_t *pgdat = (pg_data_t *)arg;
> +	/* Print header */
> +	seq_printf(m, "%-21s ", "Free pages per order");
> +	for (order = 0; order < NR_PAGE_ORDERS; ++order)
> +		seq_printf(m, "%6d ", order);
> +	seq_putc(m, '\n');
> +
>  	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
>  	return 0;
>  }
> -- 
> 2.43.0
> 

-- 
Michal Hocko
SUSE Labs

