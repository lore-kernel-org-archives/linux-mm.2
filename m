Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B717A606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sDa6UOwS
Received: by kanga.kvack.org (Postfix)
	id A0E406B05CB; Mon, 23 Nov 2026 12:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4B76B05CC; Mon, 23 Nov 2026 12:38:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4776B05CD; Mon, 23 Nov 2026 12:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6709E6B05CB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:38:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F05DB16096B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:27 +0000 (UTC)
X-FDA: 85467093054.14.5BF5908
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 156B118000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sDa6UOwS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455506;
	b=guX/156k4E0TUE3TUX/W/k9mES5H/9vpsq6qCr/oJZ6H8/KHvbgneHppC1/krZtpJvh6PU
	sxEataF1g4HF+r/iBIymn8CWrQT8S1rVcNzA8eCJ18/QvFjggAVDpBs068vsGrxTnU4vk+
	EbVvUoSO5Gf0vvEennz/ZNVJUYVVi0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hHNHNV+i9Jt1zfR9hkLZXtyIGw3mjVdQy4cVH5hgMY=;
	b=x8oD/3gbnQHTfFBAxhp5z0QjWdzlggnxJXTe19d2q5x5riBvL3HvDQn6lKUtPZ+Cb2k+RC
	B3dBne4SvPlxvxmJbeb/sR0Q4UGfM2Rc6Y1HlVh2BXNQASMv0oIn5QNbudGImTy2W9coI8
	gKCI7gDPhkomgNKFpfogeDAVREvSzCE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sDa6UOwS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-386a9c93b4eso593504eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455505; x=1796060305; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2hHNHNV+i9Jt1zfR9hkLZXtyIGw3mjVdQy4cVH5hgMY=;
        b=sDa6UOwSW55ijczbvGigyguYQVCBhoFd+Jqc20kqRaLxdPw4F3f7E9M8SpeNcSSqbv
         q5mVDDPSeWCwtHA7bNAbphyfm9Y5FOExIYcgi3NpjsBomBXA5szS9Wy87edwtY7J/7X6
         jcDqA8ogOQzgi5iPppFVTHHD5/kkAEx7VRH+Bo+zY/pHcgK890rt9oY/WHkQmh+H/YOL
         pyqQyllQxc6X4j34SrGRNwvNI7HnvaO9ZA8GLmSF9Vkv/Nk3KpsfauhzllQ+XQq0XhiW
         v3NAs4LmLIJSKgpZa+oQnmB2K1s3gSkTisg70lq6M1D/8Fh08TA6FiM42s+iYuMQ+EvE
         YL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455505; x=1796060305;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2hHNHNV+i9Jt1zfR9hkLZXtyIGw3mjVdQy4cVH5hgMY=;
        b=efiAodH6f0moX4tPtsoYFWztzl7ja2Nxx4Y4Vj7xeeHBXgeya+VUVw9g72BbcQLJTk
         z6EzlA1+lcAlqdQlpwCPI/ugB2zPIJH4fYfeM1OsbOP5w9+PjBd/JgleSxcGs8KcEe+X
         /5QTJDQ7CIGvIdfA/QmthKWYwg2SBpdlhj04CR1MmZlIBBPl/7rVP+xtrBYNOwenQh5X
         8nfKuySFz8+Ol2KbIbO8yi6vOgjiTTKKfJsctfJAZPAZcIymfnb8ck2NzgNHdYOiVOhT
         CFjkXi6WEcCRyWUbGCYxp94VLej3VrRIt86xYFjGTLvz9ZDxBzbG3rI009kiloabBnjn
         tM+Q==
X-Forwarded-Encrypted: i=1; AL+hErHRyVFyKROYinwpAhUh2oOvCCsxxZCbc2qsPA7teEl8NL0eW/9ub/FE/7DgPM8L0Rw5UeoJU8mzjQ==@kvack.org
X-Gm-Message-State: APuU4Z8wG61XH9UvFCAAvAbniW3IyLMGW+lQ9kkoeAt3u8xaN8jXmwiA
	UYVvETjS9FK8v+6T8J6I1BY+K4dLS0155ltanzEHmW+qx0718V5oK8pS
X-Gm-Gg: AZFdTZepPFrCjtEV4KlhQgFyE4nXIzoSorLR7sqKb//sPQ1Tcbawawf8NVIHge1ACO5
	jBPGXeH53xX8DVLhJF0n1fDlt4gp1pBS9uRYE/9RVdDRvXI4Y/6AQYM/tMwmOTOWArZXoLzyFsP
	EY6xEdQpe8fwZwNpkZ0xSau2maNf9B/MSOk15N3G1FGw2ipL59FKhY8dYUfjSdW8egJvc3aY8yy
	V5nDklPKx4BTX4AGbS3w3T/gYQT76P/5WmX5bzviVLsloOOr64AMR6padLIpb3ny4oq55Z7hCVt
	EI32bHUpxpMS2NbWqDOitLBgZOVOtISWN+VuiC+Vfb82HuGOmWJbsq7QXlzm76E21cbE2aHlwFT
	55l1a942UH/2XZ9CJmQJuCPBJjxSOhM5hdumUEiZTU2RJgQFqkGx6RNpWGHPkfL2ZD+nNC9A8pA
	FyRSjHGiQ6WwGTUcVA8iBSsSBsiK10KraU8nPbGtKnL5AkKChWvxgz6wMO2X93lDYk4mdXuYIcU
	OATugmPhccHvHPCGIN6DlIE3tOo+mQQAXZqhhrLQ4bai6/7oujDMQDrQeMZTTmgvKm+VpN2JJxS
	DqOdIUw6wjad7UVK1UU4UL6nlG501qAWzTg+P49XiCw8ofsgOu2b/n4ShEbqkfnix+loijbm2WA
	K6KrWx0cMRiDMnW3DiQal6kGnd0Dg8aQRHdPh+pJU/RYDkBf0KM9qyp4vgAu2Hw==
X-Received: by 2002:a05:7301:6405:b0:37a:cafa:6d78 with SMTP id 5a478bee46e88-3856ff54addmr14299630eec.33.1795455504821;
        Mon, 23 Nov 2026 09:38:24 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:38:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 22/27] mm/damon/sysfs: implement report producer
 addr_{start,end} files
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256490.4.3848004316312347610.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-23-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-23-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 156B118000F
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 5de3ibwn699rukpqu6dpayizemndhbfo
X-HE-Tag: 1795455505-163005
X-HE-Meta: U2FsdGVkX19mEudJJCVE3kgp0UAUFd1u1p1Cw+wtKeNk4JFOo8hDc6AX6ze6dIWw8t7j/f3nenxeFA8tsVpRDN7Ssxc3g7MB78d2YH1Zd8RaugeFICdy7vKJDgNhgGic8nUz21+mTXz2UHn0EABa0sfuy1NOeecWTpkOET1sx0JxM5psnuX+cbN5pe8VlTYbmFhtuV5LZdZylIblVCaY/ssb/Olvs+V+b4r9JtlW1zhXCZYiXMQ7kSkBR0JQq2kzsWhXrd/u6gSs2/M3TGEc6YO2nXR7LQ/nvR5FRJr+UmUBaCavdTF3sTpW5pVTxUKkhQ5KWi27weteSG71JynMjJOmxUd4mkK4BIhYENSdlN+/rpoHzm18tOh6k1FIEMKXXPjX3I1gp/OHGPCbiQEBI9iN/K8iOqEn8PBASUVguerzatZwOk5Ye91ZUr9dRxODj5SWnvS1j4dDVsCiZNLnMENh3U8+9+mspyoZ5VrD8lmICNozkWKzjuPxm9RtIgiNJ6ZT2Fvi0FFzEoNFZcWhTMo0L7vl0CDv/tzh1ZJ1nWMSvFBrHkKPxMqVHPJdPI6mj+NG+nkhOIpV1EsTP9GUSRkaYOnsGujNaOmQU5dY24/H39pFF4XCJU7m5jV++Lrz1ZoMMRelv/vTnNDca99011PI4kcvKZeN6IHbJ6R9SBICAho4tgCvxkqA4en7/xQ68YirocQiZVivZwnPcQbeMQKGFnWT18ZAoN4mBcx6iMWVsnxiUKrF4ffRToMcfEwTpsfDAwwbVLYU1MS9A2VzyiABFDET3vh/O39mL7RcASjXygbbzjMrOizhbkS920+d35U4B5adka67SA0eWe1J/cZmao9lylZLekzCbcZ39bb8TimuC2cB/ChOppH1SxEghRTtbdBqLDfF/7h5yHNgxOB1yOfb6m8BBT0nGhKDgBgz9+HpX04n5WPZ4CUrbFmtCTlxSAewlwc2AQKe+DU
 BB/IHjJF
 VZLF72bSd5yhjYarJOmiPy0pzt9RY9wzNbQ8O/m/oeALoYB1KHVfsok45+XEPPQzojhUI2JOhCkJxpK3rJgvapwmgiQ7zsNYQbxMGz9e5XEKOsqCgHTWR/1PIFPRkmOUv/TUzARebIlU7S7XtguenOAWPTrYPo5JzuAOHuVST8wEwLOnD52TBPeq9REwOoClaC/88lf+oiR7YE4MMVsDPQjpQ6d6jgrzpsT9hG2RiC3kAy2ek3pXemV/s/WvgpCCJKp9cBrsUbGpVmVlF+zi5yZX+Y1bCueRJjx8TPrmVy3E0q+eb6D/ZvhGYxJdzpGoRo5/hyWnakmHYtX7rPWTmdDeQvbn//aAFuW6tH7FcfHH0rWWrT4zCG6bYPk3bfEKtYXKd+qDvXJdiMqOZ5ceKIc8p4FCg6op111vWKJOwq+9hVMg97r+C7CkJJghfT5fSswJ/TAsLkb9T2HoItyvG8JbuIqhM81HTdaKpT+X/Dt54IKSnwFlXuEjq5LWABpz7jkS9yGTaIHXVHcDz8O1ORAOsQMzR638DiA8b+LGkSN78cGM41ThV+EytSHaCdbe3eN2l6a9e9KzDQUzlIW7u773aNtDAVC443KdIuupje1hPrUFYd78Ci+h23ZYw1ud4bpkzDnfTlIsuAZ2mdpZdCaX60u+n6swYq1n0sF4ilp8/8cgt4vdtpRFjA5UjNHeA93SD2T8W/i+H3FwP6CVTo/YNUCAjzPQ/lmq4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:06 -0800 SJ Park wrote:

> Implement addr_start and addr_end sysfs files under report producer
> directory.  Those set and get the address range of the user_report type
> data attribute reports.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

