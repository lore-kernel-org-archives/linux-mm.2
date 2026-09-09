Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D45AC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6783C6B008A; Wed,  9 Sep 2026 14:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628F16B008C; Wed,  9 Sep 2026 14:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A2B6B0092; Wed,  9 Sep 2026 14:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9CB6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:14:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C76061C1A8B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:14:52 +0000 (UTC)
X-FDA: 85195024824.27.E1FF71C
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf24.hostedemail.com (Postfix) with ESMTP id D65AD180004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:14:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SYvJWVhw;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788977690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzFysYL2ZWVkcNchNmKkU5ZyseGFGQP3llm4Y/4N/1o=;
	b=NlP1mEQs1yQQZdv/g/kexmcRF4/zJgoYzuNINopEJ4xo/m9AmUN5bDwLudIDNLuC1l2BSg
	OUgL1IfZFLXhqQpUPsf5XrYbS1+NnALu9nuNlmQMUkGAyq63X/fId/H9QvH4l73DkbCUyX
	MBEt+meLqvghM1f6a6nnHnqEYwy34NY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SYvJWVhw;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788977690;
	b=b5WiwTR0RFYtoC/JVNFFziGL/N8ppXsztBeiD/TvQ+X3BRdqF6TOYkeqIQIJPMXwegAKk0
	Z5PtHaesV/1Y5YawN/quZr6fFXLsRafeSm2g6h3kfiVauYvyzMXjFI4AoydODfvvGdbTNA
	kjd9Rfazgf7wLNhkUURBHlUroD2kcrk=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6356256so1106738f8f.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 11:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788977689; cv=none;
        d=google.com; s=arc-20260327;
        b=M8Nzww/KbZsGI3lfMW6XXShsJALQTTnG25cXt+VowCcwBmO+2YrhuTi/qjIkzHOH//
         2oEdCLdN3qtUsDxrlnDZvYkboTYOhjec82Sc7VpWBd0BjgJAXBwFBZ6070bwKxp9f/ZX
         1FwK+3BsQbJvx1hyTx6lfWCr9dj5ymRR03oQNyAzMyEEw9wbrJ9sLZ67buKn4e4lamy0
         voiePEN0t3O2y/D8Hmz7HbyjH7yz7BerHhnt1Z5MKpohDDXcOMsEJbqgjl4yfREUHBF/
         vHiN98EsKcjPXrvdMp96ZZtczgcJQWVCMG6o+rk1Ybzno1qxttQp1N+nYeHZScq8XN5i
         cKMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yzFysYL2ZWVkcNchNmKkU5ZyseGFGQP3llm4Y/4N/1o=;
        fh=j0T1BaC463kX/IEM0WhWnNZGUPuRMITMPG4tBKVUVj8=;
        b=OOc5LmPbew9QXrHR7OY2PCaLivJ00vI0hGzXvp67uSEx89Wiyk/OuT1d+sgGTQV3v2
         WM/gIYsZEdSPcRs73oFD7StAVHFqyFFoBrqpZ1EeP07XRZ1xEznOqa0hS8hOnGMLE4An
         G+0hmEhrXblGrSY7/8f4OpzNrL9Ahm6mHTZk3ElzxZ0Jmr9gSF4pUU1qzCXXtKiXm3QK
         fiX8nZPeNNldgdSoq0Lir0KLXVH3SKlUMT6IDAhKnxo610Ax8318pImdWxhXOnpE3tG4
         zavs0452rNh7fBvwGahJ5DcVaymWvpS9pZ73gLKIZ6m+EJ4ghjL4pMuNNMCacOZL2FQF
         1vzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788977689; x=1789582489; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yzFysYL2ZWVkcNchNmKkU5ZyseGFGQP3llm4Y/4N/1o=;
        b=SYvJWVhwFPBhcU8wMZ+7ipKAOrdjSLqIuUdqIUQWmjlxJacWnLcqvP7NmVKgVsrC5D
         YUTngKsr1NlO9heN6Bxi5Zz19VwBcOOflpSuuo/ZhMscIqvBA112jYfDJSmb0J4tZ37v
         J+lWzS9mg6ZNwBcOYfXE/h8yGhQSQ50s0BDugvioOycnwd5UVLTzhqGv7y/tWkygdOf6
         VSgUsGKU7tdJcht6vFd+36iCZ++JZGDOXQvAirc/6269zU86turHcq0AxZEx6QOI6AJZ
         IpT7/xsWFvfaYOs16aZRNho6cK3Uz75+JGaCQ/COJLzpuxM8HVEMhXGRxpaMYtKMA80m
         vy8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788977689; x=1789582489;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yzFysYL2ZWVkcNchNmKkU5ZyseGFGQP3llm4Y/4N/1o=;
        b=H7UV5NVNPUWp2Jt5icMxeW4/X4O9M5yXhn80xbgnp7dyqQVh2W38VIPSdZXhm/ka80
         OIke8tLOrjUJYaz8AjdoXqokczUc6zqKsQOp2xR70LdhiawvGZokwf5VdwqKVP9ohyWX
         pADmRxBSBF2AHlgaryeeJPJwfqKzjvoWtk/Bg6vEEz9Wq+n0OYS7BPSPS8V5dPjiV9qw
         yi9+WB3W9pOrIiNFFtFeSsq6PbJHzM/iF8L3n9V9wldFH3k38Qz1HBk5TnqiIhPqJH7/
         AT/v3Hu3ZtRUtM7Dh80WEQaARcTFLqvhIS4/90FrmuvmVU8p7JsvETNfe2K1ynFKP3p0
         YZEA==
X-Forwarded-Encrypted: i=1; AKwUvBxNtzauTDxcoGbqvhpESk6MeEDAmUYDqZKG1Z3YN9sCSINKv76DMy1v0qAgDIIETmoHmTbnBo2IJw==@kvack.org
X-Gm-Message-State: AFuF++npat/mMor6/g8SuMeR8VYSH3or7RaxyaOFtzIYuFCkTYNBHPOF
	pXwxxr8QgRr5nzq7lgzglirMldS2w3aB2sbmb/fh1Hc5pTrAN6GuzbzAeu+kTmnHox1wwI+qQ6B
	tXWtRaEsAFSrBy7LWnjyrApP7nMSO1ofK3N0PCUk=
X-Gm-Gg: AYBFou2DByYqFZbh401wa68D2YiWbBUFvfTp1eCj1hGvbJOlf35IsUVXcNp++lebvEY
	dfjy7mhFjgzrhjnB3AYI9InndL/KlYPvaZWFGPNr0BqwGz98gmDiHwkZDyLu0+tiIyEJFm+zTcM
	nupHN96flpPs4EupnbSzLbOJUceYNpXy6OzuRvEhz3jLJ1V1LWT4C1EyqWgl0y5VwCMpOqJFkFa
	kHZif3if6ej9RdoZJuxxxrv4Vzt7V/Cjn6UKKQ8KHqUP0K+W2OzwbLkkPxhrWd0257lV+AHf/Z1
	JhMuM2hQC9p8DPNFzFHuxJUPxFASizhuXzMiaZS2gDFA0g+mqcBfMqwS6OgPoayIEwwsjgLXD19
	xN563nLkMv40=
X-Received: by 2002:a05:6000:1a87:b0:485:8ddf:7a5e with SMTP id
 ffacd0b85a97d-486e0f6c965mr825042f8f.11.1788977689104; Wed, 09 Sep 2026
 11:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260907161938.1932355-1-usama.arif@linux.dev>
In-Reply-To: <20260907161938.1932355-1-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 9 Sep 2026 11:14:37 -0700
X-Gm-Features: AcwNN1X__zB3pEsdnxmwwgsAIlWtg2QfI_AHwOPpV_fdj1oiSItGXQAyV9ijLiw
Message-ID: <CAKEwX=PDTPk3d-e7z2GYka33jatuqxy-ES3uSfyg=-L65YMaLw@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: don't fail a large-folio swapin whose range is
 not in zswap
To: Usama Arif <usama.arif@linux.dev>
Cc: yosry@kernel.org, Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kernel-team@meta.com, stable@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D65AD180004
X-Stat-Signature: ukoobrdfoednp6icjg44i339qpxjsux6
X-Rspam-User: 
X-HE-Tag: 1788977690-735751
X-HE-Meta: U2FsdGVkX1/MfmG2t1tuA/uAHTHHtht8JAgFqwcKUZD3hN9x1zuk+F79LheqVLmKAGn3yrdjGaMK3cPiJIGPlFpNBkyOTnkNSwDUt2ccRCFG2Z1lmH/Fz2M0lmF4+G/bsToGGLvjw+CAEAEEFk7W5e+abA9xFNGiVr5gnigfHLnmW5iNnNIYmcH0tznBW11Zx4NMuKk7/aL8eJYC99Shn/xp/4JJoAr1brg5IOt4p44oyXOrV01Ggv2fhKHq5GiiBtvFi320gXtRv2rnJhZoCO3oC3c7A7nVSZuGaTNGYA07k2O5/LfIuFe6Btr9yE/o+EWT3ifAuMtaUGsauouFC84sM9nym2q2OVSeyQxxnA3x5icXlE8/ZPCBN2zN2d9DhviQ4ErA/b39UPbCetWGU0uwBclRzhewJgql+53xmdtXQQuqBhhASAv4EeecgI/wu8G8YLZM9Ia2jqo0U2b24A1sNfsrrojfYJ3hMQKStBmr4t24X2BA/5tbsXoDLPaAHHFZSmyEm3ZrVTmihold+K/4NiWv185dGtxybHJqlkit47DDpVdCVq64J9WjTYRWMs/OYeZIFQ6q11ET/khUrPgwt3glhthAu/bwkv8mYggrUcYEyPTDOoCFoTFz6tS12q4DWMr+5DkIhhF7zoLa09PvMz0bXNWZHQ3qLLGGSg1M3sMx+ycKx1LThwxySYDuY2l1y5xztv9WRvuZeuRoscxr4EiYMA6ARz2qxU2pvKvbQ3PX9/U3DT0shbpuZFtlwGEw7lG6Hi1qxIsnXKqu64zooCwQznC7ZTpi9bo/rxjNrweuBqvSTzPkP3JtWlSmvQ8D5utbntB8Tf5Rgxl07dl7dn51TFukubupzPeVDxg9HTo9UqqQ/xdt3YmKoOLML7Eo/pII9RCk3ATnlLwRQs6lk4vTck0ihH2Q/s/JBBe1ZMBlUqlm5iV/V5OHWcmXHX7icUDLxe8kpf+xShq
 8aMS0X32
 vVT7ULS+2fj7dtw6DcEi2qJ23BdPnAk5+v8PVcH3Q7xKs5sc+Ku9n0NGvQQVmov1xqfvvG0xEcY6Oe58QfI5PTiEfjyChXDUOz7noIdvziTqrZQVe+QBXsRgk7RZ5uSEDbTN0pxxNnQEuExCDCzGFfzdXGhxlw3m08K4jq4H5WtSjzkDAvFg14/USQ6XXoejOEqbWdOhZDikNAy95WHz0Cct8Wk6HjvuLK1Y1/Bbe96SCRDwtOLZm1mrx7tyTWIhSusyCufDIVLI31vwbN7uKsaYCh16eakXFRcgf04EmYVQP3T+wvCpbCCCr4rMDjeRaxSKWSVFgNzgg6jwN93RUUa/DygPrWLVQ0D1U2l9lkMQ0rhOFlmQM/GL4no6ECXBe6FrmR62eqJvj6w7yTsdEJSefQMereuwOOAqFB+YMsuhcIaZldLYMz3KNEtYEzf1XhAlN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 9:20=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> thp_swapin_suitable_orders() and shmem_swap_alloc_folio() sample
> zswap_never_enabled() to decide whether a swapin may use a large folio.
> zswap_load() samples the same one-way static key again once the read
> reaches it.  Nothing serialises the two reads, and in between the task
> allocates and pins a high-order folio, which can sleep.
>
> If zswap is enabled for the first time in that window, a large folio that
> was correctly permitted reaches zswap_load(), which rejects every large
> folio with -EINVAL.  swap_read_folio() treats anything other than -ENOENT
> as "zswap handled it" and skips the backing-device read, so the folio
> comes back unlocked and not uptodate: SIGBUS for an anonymous fault, -EIO
> for shmem.  The data is intact on the swap device - it was written there
> before zswap was ever enabled - and the not-uptodate folio stays in the
> swap cache, so every retry of the fault fails the same way.  With
> panic_on_warn the WARN takes the machine down rather than the task.
>
> Scan the range instead of rejecting the folio.  The caller has pinned
> every slot before issuing the read, so zswap cannot start a store or a
> writeback into the range and the scan is stable.  If nothing in the range
> is in zswap it is all on the backing device: return -ENOENT and let
> swap_read_folio() read it.
>
> A range that does have a slot in zswap is still refused, because zswap
> stores large folios as order-0 entries and cannot reconstruct one.  That
> stays reachable - a slot shared with another task can be stored inside
> the same window - and refusing is correct, since the alternative is
> returning the stale device copy.  Report it as -EIO rather than -EINVAL:
> the request is valid, zswap just cannot serve it.  The only caller
> distinguishes -ENOENT from everything else, so that part is a
> documentation fix.
>
> Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io device=
s")
> Cc: stable@vger.kernel.org
> Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Nhat Pham <nphamcs@gmail.com>

