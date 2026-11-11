Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4DE5606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=XEWfkn0X
Received: by kanga.kvack.org (Postfix)
	id C6C8F6B05B2; Tue, 10 Nov 2026 23:35:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D826B05B6; Tue, 10 Nov 2026 23:35:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0AE76B05BF; Tue, 10 Nov 2026 23:35:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83FCC6B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:35:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0941801E6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:35:43 +0000 (UTC)
X-FDA: 85421574966.17.DDE9932
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2899C40002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:35:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XEWfkn0X;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794371742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+2K1wGIVnYOeoOARc9NS/daCrePUls7APEF5NmFi9U=;
	b=wM7FkYHGP8fWKvEFyYHQmIgZZ55RumNY3aLJqPvzTLf5C1zbH3VCq0P5rrpRVPRe2V7c+U
	yi7WCMbH0LUVm+dMCLD/VXVy6wZSgd+gLJZKdrpVZqTANLXBKg9egCEuc9DztH3CAtjjZz
	yHh5CEX9U77BuU+eCceGMMKslNwp2YI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794371742;
	b=iggzXw6k7e+U8wKDVGJWfbxEpye8Xl3/sXCe6ZJoa6P43TFPljxdV05CePxdgikdjGhGVs
	6KAshjVY3LOK0JX+pjWzNRrUUiywby2HSkQiPNCyAN04sFF2S5GGM3Q+lQgEiJNn40eN+Z
	ecjyCukwgHCZGjKr16PjJeFVeM/4P08=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XEWfkn0X;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e9eb579c0eso15691865ad.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794371741; x=1794976541; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d+2K1wGIVnYOeoOARc9NS/daCrePUls7APEF5NmFi9U=;
        b=XEWfkn0X1TVr4fYGNIqWm/KDEzwsKy0Qt3QoriZTfCgfpzUJJl0rmvr+4dbgXJtojh
         DdtXc3+hhGsQ9CEv+qgPTR1tXALRKYZFVrxkKTPc4h/xJeoOONbYtmJaKxPT/NBsBJwL
         gpfpqjlbvnb72D+W3GqnW5e0er3EhNy2EEeUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794371741; x=1794976541;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=d+2K1wGIVnYOeoOARc9NS/daCrePUls7APEF5NmFi9U=;
        b=NnUa0cz3yDKYDznqP87MI65dgYaqJ22P4aKQwqV5pA6ERWXufkiPcRGF3HGDJwdCE2
         LU5KfRU9qnkJR+boVYbHt6uqc29WN3Os7/pG2ZCDvVGLVihb3EgE9/BbRNXv+VIeH9lt
         DytVugPlyqMSmc87dwaPczP8l3tlF21g4xe3RibA1CdkmKEZYSbw8aPXK+c4dw96ITUr
         8hUV+eVmSy6wPDaiaJ7mtdL3T4WOT4VxWNi3JMx5TrrnfcHWT0SN9NOXXwGhUCeVH2ol
         SXYjlPJKaM0gL57KGfM5tmyyzBCkBjjOH18bKm/j8WHKrvAmKM2cmTnpzu1DGRRvSVZ0
         jfYQ==
X-Forwarded-Encrypted: i=1; AL+hErHaAgRfS2CMUEBQ0TqFH73xf8FxuRXDPvxMMAAiHIxAYCjNIaqa1X788wVPHuDlxA7luIB8QB9LGw==@kvack.org
X-Gm-Message-State: APuU4Z+OnmXT7V7+PXZnHxK+P+uVhhGmvtWxX0kPpw8aPw2GY1kRXu3h
	Y8EEqmtUvt3iMNN7CneToilta1kL+ev4p+WDtK+NgSAAyN2MsjYrg2oU6VxChTcQxg==
X-Gm-Gg: AYBFou0gr2bYouG6UYnq9lt3zKqLoM6Sf70PY2wzTi46ZldrqZFU5roMA4mfCY44dHA
	CgV7B9QMm+x+i7DOePO4Fg5sHfPBEPR1AOfJeldmB2k9MjQtq1PhgOMczx42kdpIjV0FuFS2GNk
	fUMQ8yTHarmJ2KYm+xO615i/eexfuY0kRYEZxJDt7gdf8kFhRhqDCCEjSGDn4GY7ZBudeGs6/OV
	oguwCf6NPsz35LC/oAvqnBfi34IWl7PCwg8zN9tklHaqlXlXDtU/zj/3AX0b/k825UYxUexBAtU
	Ryv4TKGahFT7tzfPD3oV4mkAEW7ntwNZDHuLiuUTT/oxsQOtMWE52HXm+yvjW4XF077kga0AeuJ
	uCp5hj5qVUCs4vHmocSMdL8YRGj1bbPrnlSt/OdkXe6yueWSwOAgD2jpQESEtPiCQlOHXOOipl5
	qc/TWZmzhxae1bVYvw5cCGu22tvTanACJtfHUjQUXuSedhG5fHREtE/zGDSgckQwlxt9Z6nBVgG
	onOn5Tz1vVmePwhX1YyTb51GoQFe4y1VAvwT3YMYLV4SgvgdR49x1V2V20vY2E6H4A5RLLncH/+
	SBFp6/D+jtJwJXeTI5XqvmCUsl8WujXHxYcu8ZKvh0cYVBdhr4Xbm14HWNZhju8EdGqopg==
X-Received: by 2002:a17:903:1b27:b0:2e9:7dda:bfce with SMTP id d9443c01a7336-2edd7b85ea9mr12903415ad.74.1794371740975;
        Tue, 10 Nov 2026 20:35:40 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm16527065ad.56.2026.11.10.20.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:35:40 -0800 (PST)
Date: Wed, 11 Nov 2026 13:35:37 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
Message-ID: <avPwLHMalD_kzD-z@google.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
 <20261109-zsmalloc_stat-v2-1-caee41684aba@gmail.com>
 <CAKEwX=M6dJMccGcDqp2S-66cbegdivnB6MqQRj6tQ2u18UH62g@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=M6dJMccGcDqp2S-66cbegdivnB6MqQRj6tQ2u18UH62g@mail.gmail.com>
X-Stat-Signature: d15xjyk1u865t6494qn1xemaha419xxq
X-Rspamd-Queue-Id: 2899C40002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794371742-489003
X-HE-Meta: U2FsdGVkX1/U/bF8hgC9uQ81n5Q1V+Jx8ZarBJic4OQypj94XDq0R06GayyG7bMTAo6sCVz9XhQ5IAUVbqBCa1N/JfScAfE5WUu68JpD1QMQ2F+gY4EsrqrRQHsiYOj4ycD0aQmkZPL65LD3GP6nECZsQfv42YoqkOwQJpeg6NOGI2vEg8iQNAw0E5kH/LJFDe0jQP2OE1MrCXCZYDOFxldXKtgckSDsaeUUQBeWg+JdChpu++o74oqwyci2j7dk9zdaqrlvcAjtBBCzTvLCifyojQh/WEHDIxZb2bjxUovKjdUzHADF2Ywb5iflH8xG0sz4gjryLTHXGA667p8ohXymGzursrMeQpffHgbZF1/D/GnCL7Xb2ekfPsEKI3mmdT9i40oZjIp4ZdnMRzIcf6/fGiXV3itBobWSR4tqqEc1sUE/4x+l0S1kjWfGu4BHbX89EXW6uFGr833pnKk/AQYJNWCCg62ZEUqsPd4kc5w5iPl+UyK1b7BTxbuGqONpAV9M2G9w1fKHtrXiu/2hHEben0LGVSHqMpv0l8tgCTBBBFELAymf7d2+rVBLl9H75cDiCJdkgDcfXALebwp5099wN9R0qACXOWlNprqgjFUxS4kqA4k8a4NW6uqmPNooUPBrsCWgqtHZpH684vELxWXwIIqr/c/fdpKpi9OETrBry1GNJfyL7+Pt7aClemh3XkID4MYyUtSeWPuWSedtW82T+P1KYn34VM/UvRFsPlZwe3gShHHdKz9VRiiX2/0yQEwbvnosFsNwsHkIub8KOEL0XdntWWfQw79ngGFP2NoyH7dOtMlH52wf9JoFWU4tgCK3JqoIimmsfdMXcXlPgOdNseXdsuJJCuendj5blkUBZvvwwwFjTgWtaidccaaYs4WTAZ3S7mGRRaMrUVascvbqt7qU30zS8I003QstCldz2gvnLFsoyFT2i8tYlxumkjNRscFSMrcLfS3T+w9
 nH+GIg3k
 LMvzXWzYaf5nOQNZcahrpXdKIODsh6QBVed6f20x5w1ISt67+yoxJZtNPOQkYgAnQF973t6Dx+31E8N910m+T2EseGx3uT79+rYaWO8sGlrV0WTDJcZeHyNs+ielCyev0hP8m/TRoN+FZ7RiPOiM+efZ/gj9Eq+2ep1ZYh6heI+l5sCPSPIk68a1YWbmZ+flCFhPSGaf3EWun3pUvhtjPAUZSZ2JhrH0gm1GiGxxcQ++KzufQaX3UuXLbwSQnd5MHrHQJihSLXP4Rjr1zsxiTseWBkjFt0tzBaWytK8beyeNhSdf3SKAM1oxiGpcSSiCERRFCMw5kr3+oQ5FOnmmV1iJV/HM6UHpWgig0ujiAtZkGZnrwFD3H6poeiO6tFWRJ1edEciVpTWMOgKoiHbUCBKQITAOpqTU+YtdOgsoPJvDCLB7rV2WOXvmYBzet8eFRIIKyLQckAZqEcU1zyc+GyDssTn8zYsbRoRFzymowL4JUih4zk2ATtvKmSsdNHex5y+GRHtWdks0NeTMNVM5MP7LgwBrUVMthc0nsPZ71qzF0lv/h+RAP2VnbdhORB7m+cWYX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/10 08:00), Nhat Pham wrote:
> On Mon, Nov 9, 2026 at 5:59 AM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
> >
> > CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> > counters are updated regardless of this option.
> >
> > Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> > stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> > debugfs is unavailable.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  mm/zsmalloc.c | 33 ++-------------------------------
> >  1 file changed, 2 insertions(+), 31 deletions(-)
> 
> FWIW, LGTM:
> 
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> 
> But I come from the perspective of large(r) server machines - I'd wait
> for the feedback of embedded folks too :)
> 
> Sergey, how do you feel about this direction? We've run the stats
> collection (even before we select CONFIG_ZSMALLOC_STAT to expose the
> stats to userspace) for eons, and it was never a bottleneck AFAICS in
> our fleet...  And the stats files seem trivial, relatively speaking?

Yeah I guess I'm fine with this change.
I think this can be just one patch.

