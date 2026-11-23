Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A1C8606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XQ5d6GPD
Received: by kanga.kvack.org (Postfix)
	id 545006B05B7; Mon, 23 Nov 2026 12:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5956B05B8; Mon, 23 Nov 2026 12:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6156B05BA; Mon, 23 Nov 2026 12:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0021E6B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:52:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CF9E120962
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:52:15 +0000 (UTC)
X-FDA: 85467127830.28.1CA2D13
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 64E57180012
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:52:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XQ5d6GPD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795456333;
	b=5Al2tzak7VVsQFnBp7uQH24sOlGnhGzVT0y+N744oCn7QQ5m1OgP/YfXTxfRQxkUXwt4fS
	M62UnkBep0MmWjoF3grStW4XzCJJBRI5vzL/lFffWgtACtMc4TZJjivhHFPh65aFcbh8vf
	SRkE0NDpIQfFSBoSZuPcFuYRTQfYkPk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795456333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MG9wth+FgKJUhgMgr0LKB7NofqtOeeE2/Q/8//33IbE=;
	b=CiASyObZuj7OxVzA625rjVlgt9/kHmJHxFSekqu35q0Mctq1LwvbwNkRFKRC1RtTp5lJXV
	dHdBAm3vDRmjz2O3BQ1eAw48NA3894C4x+Zf6JUs5fQ8rkf9DF7BV6LfAv/zCewUZLhCm3
	XXnDyNX1jb+brfg5Nup/U1iuQevfRf0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XQ5d6GPD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3adfcafaabbso29507981fa.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:52:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795456332; cv=none;
        d=google.com; s=arc-20260327;
        b=mWsr1qmRfFTUM5Wz5xm12bI1IPBvQxD4tM5d7p/PQ9TZdEKMQortMwcuMAdNdGABBD
         KtSl1xYunD6GOxAfP7sgYySa3z1kEodWjybvqKdWotUZEKlPLvZgTvVhtC2/BRhuga2w
         lndU9r/W1jlV3hsfuHmK2adBAuxE38TsO6BDgOF5rlyWlXUTU+WiEQDI8XzJmQ+TnMi1
         QgHpApSRPXFBuhj8DFzpYLruR+bEQmKPH/X7wewtGWTvOhJcTWRSxCk3pOXsVPgZjjtK
         qKxU98p+OfPhwLPE6c6rOX0ag4O1i1FGt4lF2DobhHXQ5fn7IyiFw9vGWaddQrnceUHP
         7yGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MG9wth+FgKJUhgMgr0LKB7NofqtOeeE2/Q/8//33IbE=;
        fh=JTDiT8Pv2kTy4KldZStjj4m+Pn8p4/BJfJy/zi/lH9U=;
        b=D2e3X+xKeNwp/Q1sFrRs6Nd/Xuf0s8mkgrSr7gir6/KM2KvzW2GOc9lMSE0/YnC/MR
         SPioKj9z0cHcBDjvRmq6qadEro4Qq0Z/pLGbtVwlzI3oBOVjzx0MDK8yBPP7DoAbgOPt
         Gd9ElpYFYoEiASvMIFHoRb2gnXunlciQ0ouriskLEw7sybSmM2zDbAfN+h2Lv9lkth3L
         G1jSvYvB4Ua3AS+Xm8UwDkQuFD65NpO6J3NyWZG0EdCEO8wKUrLRaxJSuqJK2dM9jwIx
         yzk0iLroaac+tO3yCtekcwDwEXX/7eo9frEcW6QTtj4s0JYA1JIJDhl8bu/9DY+PFMHo
         nTuA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795456332; x=1796061132; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MG9wth+FgKJUhgMgr0LKB7NofqtOeeE2/Q/8//33IbE=;
        b=XQ5d6GPDiih7GxEXvX8s91BYkMlossxT180Bd8zzBqfTxK0Vi+ZWelUHfKnO1kRoj9
         OkIitPAuRIYp62vpz0PRmh+QFbYZZn78TrNa8PZz98PW4zASNqmF+svClR8tXofLPwtt
         E94uFhGbCEnAi28D7gqfiXzoFPgv1o98fzw5o72FX8Qw3KF10fpgrXH4t1xw7LdMKeOL
         pMEhyzhx/LGJla0Jb+gYJ0Iwi52NpPmn6H2q5kzP7OQIRXfEyhr5E6VIlxQI74Gg8KcE
         k7/7xU69jSpg0bNhqb3jUPh9lmAPIQMY7FxJRA+AbpWWZEIk79cTYSTDiX7TUYgrCk4+
         Xayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795456332; x=1796061132;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MG9wth+FgKJUhgMgr0LKB7NofqtOeeE2/Q/8//33IbE=;
        b=BLI9UyKiUrBS1VjCWxhm+F0yDzO4pWhMD9RsE8Xr3TRRzAyMqKV93kHmFxIejRCfgW
         dmTPysKEI5Hq+t7E7TUJNoWx6EyLOrU/uysAfeXNyWV3kNtR+gKNpsBdpqdIH5WqAVDk
         BdqZJw5SBLAF/OYh1A9ufyypKzVgTenT0I02uMcLfUSdKW5QsFcrUvf8XoC/tmSvoa60
         pugxfoge7Hnbr9SMNuW5P5BI3gtTXsYJa1UEgRSLa6ob9kmHta4NXAZalL/ViqVNLmu6
         cPnO4/Lp3NpZ0ovgcj7Jl/9yJpIy/1AxQpIAxO2p97Oz831VoJofQ1cSv1MfVE77N/Ic
         LHyw==
X-Forwarded-Encrypted: i=1; AL+hErHGKQj4Cf/GjJNVtYhOBGTVZ9eYI9atcbxUpQ9P1argMCmgEdHDWTCGqIuhVtW/yTm+faVTQmGGkA==@kvack.org
X-Gm-Message-State: APuU4Z+O/QshLkOpG23dF1viNwte9Cim9cixTNSy5Pfb9P00gbiqQUXi
	SZgtj9u9/I2fM5i/0nqH+f8kMXb1bxlQw2dlp9Yvf4chMsuZQ1zl8V5WpePX+qY901yUKZsJOce
	/a4dWKMknXX09A/bYrL8/gNMnOvbEP4Y=
X-Gm-Gg: AZFdTZf3UKztVtL5qK+zyBJlJUSjhCihahUTSAkv2YFYDlX1xoQ6HYdCVz48CMyqIS6
	9VYxQ3YtsAaQoNxfB3wDFYi64d/CVkxp/sxUzybbfPBPso4FERAcVt59Q2y3+RXPC9cPWTEvLSE
	5XUyPeXCMzsuSgtKl+9sX3rZ+bLTSMLQUdTwVl3JGiJmj1i43E5qa0+eYp9xS69FUJLDglKiiPv
	w4zJAulCVnFoT/rlxMP9i0H7yzJH7s28eODNuZnjLpURf6h2RZNX5eGoSGuG5exeGc3a091JUZz
	85yvi/HsG1YNK6+m0DSIK810CemTVrC3nXcTcVIg5PNdxTJacn2CAD2j4qG3fiK4ODI1TlpCNUG
	PNSUu+rsKNiruchfWVbQa0LVZLczsbOMwWF9i3YJmi60oD+YORLNFnfVgf+542p3gkhfAR7zthW
	0tWVIUdORg3e6h1eP3jzkh9XvVt4CJ9YnPKcwPpcgi0A5GqWiBcgsL
X-Received: by 2002:a05:651c:4217:b0:3a3:3170:5420 with SMTP id
 38308e7fff4ca-3ae7f8d44b2mr28562781fa.3.1795456331357; Mon, 23 Nov 2026
 09:52:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261123-shmem-swap-write-failed-v1-1-41a0115dfbf1@columbia.edu>
In-Reply-To: <20261123-shmem-swap-write-failed-v1-1-41a0115dfbf1@columbia.edu>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 23 Nov 2026 10:51:58 -0700
X-Gm-Features: Aa3M54oC7mW_vSMsZDK130KwbXWLigQruCSyLpfj8hjGPNFnBuMpFbLJ5HWExyo
Message-ID: <CAKEwX=NSxxQ7DB_CbFXNV9TZD8ddwLJry3Unab1OjnFPQwR6KA@mail.gmail.com>
Subject: Re: [PATCH] mm/shmem: don't drop a folio whose swap write failed
To: mt4022@columbia.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Chris Mason <mason@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Tal Zussman <tz2294@columbia.edu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 64E57180012
X-Stat-Signature: qfyntsawt1nyz9ssnupu35au5zt37hm5
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795456333-310279
X-HE-Meta: U2FsdGVkX1+xoV0ydly3sE2BtCpe4/P8hIhhsUGUBav0U/VdEr+W8Lgrqzb7RPVcXua+cK/xJa0LuWHO5vpdHg+FnngXZMnob7LZOzswcG73qCwCIx2SH1SRkFIP9IhEVdliOv5gXGHkmTciBrbyIO3I3/dg1KRFrPGdENYXmFXq1E8AvLc1Y6nTdEeGdlqjIktT/fdBOcDPWJRx+leBTPvR6U2RRSsSHC6Q8iu5TfGOH86Q/524fn5D7c/fhCHvxm5MCBD1G79KsBLeqzfUyR13cFA8Qz905wwtt2zAJeXt5/kdIGzj0JVpxwvLprsJ+UntwPB8oc2qeuHfkYKEwxi7tspXyIeuPfk8KtblCfPG+G9NwWJXpBkwSS7ZIylvb548NF7B+GLGT6akcHDJ6li1IoyfIAX4oBhmz2Z2pXLyelamPfGnKmHOLatduQ/EgExwTFxdCF6i08Lz8ApNy6KQ2M54iqzMuCQ63vTrPpi+6ZbPgIt2oXvu369Z5HORWKAN55IVQblpd5B+NF2mHdIu7e65cnnWwGLwmvBU1pIGXZtBlHmB6M8y0uRfBj+OYb+YaBuO5aD5U7Oj/fNaMKHl0Yyjq7Ule8tkQ45OXIzw6KrR/lf9hjzBfo3R0wBaWu8rfJVvUrqoxOGtMKdT/iUmccwDDioYTArpC4/CyfCq5ZQ7Gw7l02B5FC/ohuHImuolwWocTQ79muUTX7JLcJB8f5U+7DQHYQG2Y90LAtkIl99YbE3aVOnmJI/LzQbUbH7239sQTtbCQzgBH2ime7g86kpOlek5i0mv8FIJ14bzXju772P3UQjwXPgE5zYIKsEKnHZ9pjnT4eT4Fph+vTTkEuTW0WGRScVBBz9eEFlq2SlSXkVPataE0E/GcFgSbPJOqCi7okhuA/kk8LHebKpN495uD1So+F3XDdEU5FWr2IEEmAeF8fuCbv07kwyKqnJ4XJt6zqaN4rVD9E7
 DLnfyI5f
 0VG2kYGJTfwfMYLpr7jWRmWv1F6wbr+hxLhDOTF2ldbEjb0XpWr3Hq8AC31o1dodG6UXoXq2g4oVxexKJ0GAvS0w4PQfbqvrSuUwHA9j6jzzrecHQT8JmPLVtdv8gVQTTd3pQtE3x4c7dnZ+F6wzWPNZ0bTbWbGfCBpIPMVZ5XUJZxgWNf67bZY8wQbXdcy2X4p4xCqfraWZKtcvl/G9VFu8CdAtaSknlNTTmj4PfBNfMHm9reOnreskg1PL/RizTb2yqx+d6pqhojtYID5UuxHXtJaFiWcdiliFWP5iIOjCqw2W+22O7pHfYznz+eBQ6MVs2VtXWKczuh47qm3Bnvib5VMf2dRIlQhf7ffIN0SONbNRZLWdeH/R61th1oWg1tD19BZnMikMDk6HP+CVfd4MZWU57LVf+hHrvk/X2aRMnXyzlRv0GaeQX7rEKdRchY2EsvzX10ZsE33dp5ODAGeRQ9zGG99NpTZlTong04egi9OGGOoM6QeXB+AgJX1zyaVIzUamX+0kHBkhqEOpWk33LC630BL7HfGV4CPXDWXnccz9RQLSwMqiyYwvnwgqtjjuIpNLGFmEdlCnbquT42Y81w4SY4e59Xyq7CInd2y/lxTVKkFyHIYDgfAIrfQaJD7QkWaiG8+rfGOSb98cTVcT2bBzV5dY+KX8r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 10:21=E2=80=AFAM Mani Tofigh via B4 Relay
<devnull+mt4022.columbia.edu@kernel.org> wrote:
>
> From: Mani Tofigh <mt4022@columbia.edu>
>
> shmem_swapin_folio() drops a large folio that does not fit the mapping
> from the swap cache if the folio is neither dirty nor under writeback.
> The folio can belong to another file and be under swap writeback, when
> the swap entry was freed and reused before the swap cache lookup.
>
> Swap write completion does not take the folio lock.  On a failed write,
> swap_write_end() marks the folio dirty and then ends writeback.  Since
> dirty is tested first, the folio can look clean and written:
>
>   CPU0 (swapin of file Y)             CPU1 (swapout of file X)
>   -----------------------             ------------------------
>   shmem_swapin_folio()
>     folio_test_dirty() =3D=3D false
>                                       swap_write_end(), failed write
>                                         folio_mark_dirty()
>                                         folio_end_writeback()
>     folio_test_writeback() =3D=3D false
>     swap_cache_del_folio()
>     /* X's data is lost */
>
> The next swapin of X reads the slot whose write failed.
>
> Test writeback first.  Both flags are in folio->flags.  If the
> writeback test sees the write ended, the dirty test then sees the dirty
> bit set before it.
>
> With the fix, a folio whose swap write failed stays in the swap cache.
>
> Fixes: fc2c19648d68 ("mm/shmem: fix swapin livelock on a mismatched large=
 swap cache folio")
> Suggested-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>

Good catch.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

