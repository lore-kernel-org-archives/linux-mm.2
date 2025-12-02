Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF568D1266A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 19:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E696B0012; Tue,  2 Dec 2025 14:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E156E6B0022; Tue,  2 Dec 2025 14:24:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51B56B0027; Tue,  2 Dec 2025 14:24:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C30146B0012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:24:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29E37C0311
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:24:32 +0000 (UTC)
X-FDA: 84175507584.15.29118EA
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2871F40017
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:24:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KrOiT/Cl";
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764703470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItDOClnB9rHsRl2j3htJV8Dizb51nQfpKAcRcZrVh4I=;
	b=U3o1/73WVEGTsYN0ZJGRe+3cOIHZfSKuTYwKwt2nAOiALRW/DMqJuVnf3NshMfUjnoVPgw
	MyshopCZaTIUD2i3XUM4Wv2d9FKa716bgMYLnuuBpkkqKUpCJtbh/AnJOlI8+OwVPEr0Jt
	9W0y528wAM5Mfyv4hbwWubLKEBdEAnI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764703470; a=rsa-sha256;
	cv=none;
	b=exa9kNEml3Yk3jmSp+xYbj6hlv4v0UDcJS5snf4ZGkeeQ970hfBuCyK1IEDLBtNSqZGs4Q
	qMGAEelR7CHam6D+HbwRAT60Aw7YDCrcFhbRKbMXDbs4CGsAEanbwf2c9CQ2Xl4dRzsAOI
	IbC1bWwc7fxUSjov4TEM+TQQGgtQ/t4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KrOiT/Cl";
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 2 Dec 2025 11:24:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764703468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ItDOClnB9rHsRl2j3htJV8Dizb51nQfpKAcRcZrVh4I=;
	b=KrOiT/ClG7fAeDuTNt17HlI27GXbwiHrL41ptmFG1CNbpiCwKHmfjWuD4rUJVs0EsWK/04
	7rYZMhE20goaUzkb95rBUjJNuzUyT6QF3x9E2kjUnjQJ79XgLNmqRobMLNVzEoWI4bb/Qg
	reK/8rrRfsl9dz+aSGsHS9e9nrL+fss=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, mkoutny@suse.com, muchun.song@linux.dev, lance.yang@linux.dev, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] selftests: cgroup: Add cg_read_key_long_poll() to
 poll a cgroup key with retries
Message-ID: <bqbyraqz6ztwxd5hysw4ufttbb3ev463su4wyhipsuvau5bw7n@gzxrmua2aldf>
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
 <20251124123816.486164-2-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251124123816.486164-2-zhangguopeng@kylinos.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2871F40017
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: ceurahrtms3kgfxde7o8rp9xgeh1g93m
X-HE-Tag: 1764703469-155061
X-HE-Meta: U2FsdGVkX19L9VldkNYZ1X2Vse/C+FYtazd4hdp2Z1wuS2sTXVpn02qT+4O2tPArqgIs2oGpKxbuWXGDGC/VnX7HjcE4Uliz4p7vrs3qP65WmAWs5YnhcRWnJJ43vATwU0EFuCTQeU+y4LzbvmHpsi9RpUJx/1FqV0jIkWNkCTGQzEwIMk0jZOTOHRR/9iytQfL1NxuyulpBEgEyM972XPX8MCrY8xBTGQAwxzLRE1K5J3HZavdADtSCE4sD8DzZp+/bqvgjFRw2dgfXA1yNb+vmcnaT3RRqrvLe4ZDicHEtVJJCls3w1gsZeR+FI3M8nNw9NBpjOW+gu4JAP0aDVyLJCUPlgJ5i1220FstRefQ1vDb7NT9teybfCspr/sx9VNPIKq4NXgS+nYk6ydIX63O1sui2f36F4aAs+56piNVRiFIS+/uCs/vEE5AMcMy3NvQmpB9y0TXc9xZWqNKa/nvEgW0DRXDsWnk/iUf33SnaUvwOWOahDjORMU+QFcM+e4BK422/uZq2Wp081+8F3kLOvLRsiB/KI29oI0WXVVIrvux1gnL4Tbhf1PFBlsQbNWDt0Evwy/e/ReUPLqmwLz6oMOB+Ve+cC2SlOicmv0x4dFyMmLIirBRbbKW2XoJvlSMhZnHuUovGvkM5pS6h1XB8vqZeuQscYMDNFB/VPYnJZkJle5euDFGv+9nNue5yjyjvVSaeGpHKAl4eZNg8eNL7L/dfc+2dxlX1trKogAdjJ/cxUu+PAr1OZFxAWgDv5nMai10hSTBfCv60TtZVqHjMZq30htGr4tLffGjUTT/xV/oerMCtAJHVnqp6rG0dQr90m1/pgPbcbvRShBADwK5jdICpMkCnaEPMkVHBjO1A34F3J73V171pyEX4YGFO07icNBm3GTIk21HE+cKELVUsMt0g++z3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 08:38:14PM +0800, Guopeng Zhang wrote:
> Introduce a new helper function `cg_read_key_long_poll()` in cgroup_util.h.
> This function polls the specified key in a cgroup file until it matches the expected
> value or the retry limit is reached, with configurable wait intervals between retries.
> 
> This helper is particularly useful for handling asynchronously updated cgroup statistics
> (e.g., memory.stat), where immediate reads may observe stale values, especially on busy systems.
> It allows tests and other utilities to handle such cases more flexibly.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Suggested-by: Michal Koutný <mkoutny@suse.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

