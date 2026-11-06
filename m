Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B5C606D813
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TCPI1cJA
Received: by kanga.kvack.org (Postfix)
	id 7D0786B05B2; Fri,  6 Nov 2026 07:19:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8A16B05B5; Fri,  6 Nov 2026 07:19:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4936B05B6; Fri,  6 Nov 2026 07:19:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 555266B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:19:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF4EA40DB5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:19:02 +0000 (UTC)
X-FDA: 85404598524.15.7F4676E
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1B023100005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:19:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TCPI1cJA;
	spf=pass (imf05.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793967541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0rdYCKEnZd8FGC567jnfce1H0VjvyM0Z9c9ULvtLp8=;
	b=ooCbxWHAVQf7ofpyLdb7zqw0EIqy/s9m9Oltzr9ShRhObZEjGibNyAwL7gu4h5A20abofc
	NatEIrwxrxxNHVAXAFZadpSbMtmVxfWSox0Nn7D48s69CTxxjaAhN/eUHHklHkUDgOtSTA
	CEh+XulgMJxHKhHyhui6otuPo5NDM/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793967541;
	b=e4Z1mJecmuA1/49WsnVTeEvupTnVfN4vw7wPFZPhYyHIrmF2HS1LKcavezZ0Xw43UBGLG+
	ZPVlxhxFYIEFJUT//FNRQ7Dl6ioEQMXexckW0QnZPUlnfnErghqaLVETKHz291xtV5mqW7
	FAeNefRanWspqIHQK2s5LOpsj64uePs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TCPI1cJA;
	spf=pass (imf05.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b271e573adso240189b3a.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 04:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793967540; x=1794572340; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z0rdYCKEnZd8FGC567jnfce1H0VjvyM0Z9c9ULvtLp8=;
        b=TCPI1cJAS+HeWKDPfVu1YqbXgJMfQVXuR3GX/6KWwYIvLdRL97YXKd+mr1LtcjPuDL
         mvKBt0NFALjyt8M5HPXP0/fl+svHemNLGVIWYvNgjK0NBvfIyoAwPEbReQYZ3vTIxTzr
         Pf1svOT99wmicBX6KpKE5+Xm6CnziICY26WfNfbtgPT1gdQnZ3owiW4AoIiiKGBKCXXb
         +plN0Vr+U0E/s/+sJbwvwXNLW2W1200fHl4Sjy8g1QR1VaeSNJ9eqoNV75Px11eHICaG
         nl6np7zopX7rCMpow5ma2bQ9ICsuaGw/sA1Z+ZSERJNkggL/RdKKitbM3AhUYD2M+Bth
         ZFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793967540; x=1794572340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z0rdYCKEnZd8FGC567jnfce1H0VjvyM0Z9c9ULvtLp8=;
        b=TYCvSEOwcAvuNmB/TEaiK6Vhfch3wN5WNvRzoaP6kAMVjuoTeG/UkuBNl4W9cNFT70
         CCnvBMrN+JyjjPPxcPTo9dwhQ9t5J02v5FaX5ECnG3drh4RPP8u0TX6D5dEAxstlxwoc
         3okXbY8YBRKxBHksA1LIIQuNeZIkZWjhLVtDnLs5D2b4T24Jv1sy//0RBPJn/e5IQsgb
         XRr2Ooodoc1YHep2iTDoXSvHH6WhJN0vHnDb4AduIgzmkTLGVzSrFmtVw8wkBND5NkDr
         9qghgyhiGSRWfWJRB6yLkMG0bDhhtdkG7ZFGI+yoAX8q0IGls5gOU4pGyxAN7EE+4Zjp
         LsQw==
X-Forwarded-Encrypted: i=1; AKwUvBzrUxrjoX10YhMUFJsn0GAqmQzeYgF4nYcRaAwTikbEpERSGfyyG7rljDd0luiUf2XwCkN1LEH6sw==@kvack.org
X-Gm-Message-State: APuU4Z94nWb/1aOkt26kx2gIJPiW2v4lmeQsM8wdTTe64oICzjWjMsHX
	+3CgWFfU7385F+VAKbf91BkHmaVMXo4w+vwczNjE77M/+bsaJJzKYky3
X-Gm-Gg: AYBFou1qAOFfdQ8v4sfKq6nDOBHOVYuFqkvTtUSqqtMyV5Vo8Neop75W+wy+E8XILP2
	bU1QCyaApfwwTjtKetPlYO/t5e9uGNjkpLSjW361yTm3g2od+6D30q+8dGDD+mS8U43yUdAV5rx
	MF+a6BeVzIE0kYSUO0JhNwm/P2mqz0Gl3gNTkQMX9JfVT/a/LxObLIwvZThpgNay6WSePRGOBSf
	Iht4yO8rFEdX4pwePx/E9N6cN3kDAGMoimMZsyPbF49ZarNeLJQBx5are0O0LjbsHk632oUeptZ
	5uncQLVaVEjjdP9qj4CcmM8r7m4uWz3pHUEzsu/8G0FRnt3JUlLvDUvx1PQa++CIW5O2t4n2oF0
	5M0JM/3pRrldAw3IXKTLI8u0pn1VwyBkJLs0YsH9tHH1wSA2mvFC8LACL+3CV4CJQymd9tSwPvx
	wRXmgf3V2IYy4Q1G55kS0TLggyXGKUKWivNmYQadF91VwKBl/9qbbst8eFEPp9WammCCVjtoADe
	tbTFuj5aou/OrhhO7cjPJ3WcynFfj65BYftL9RPeidYyyD3wroGF4FA7i6lzf3pfuJShNdyoqvf
	KDIKg4quadrnaROYymD9VnGkEURLtyb840bNtRo4nlDtl65viLcBCqDoO4MY6sIbROk=
X-Received: by 2002:a05:6a21:2d98:b0:3e2:afda:c37d with SMTP id adf61e73a8af0-3ebb29a4f9dmr2641715637.60.1793967539621;
        Fri, 06 Nov 2026 04:18:59 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb706494d6sm517562a12.8.2026.11.06.04.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 04:18:59 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: vbabka@kernel.org,
	harry@kernel.org,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	akpm@linux-foundation.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: Re: [PATCH 2/2] mm/slab: don't queue the page cache work under krcp->lock
Date: Fri,  6 Nov 2026 20:18:52 +0800
Message-ID: <20261106121852.3124703-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <au2fUYzBLv3uvj_2@milan>
References: <au2fUYzBLv3uvj_2@milan>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 34s641qigiqqezr55xtzsu9x987ebzuh
X-Rspamd-Queue-Id: 1B023100005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793967540-799052
X-HE-Meta: U2FsdGVkX19+DRSySnBcB/I0rXcI4ls5x41vI5DHc7KSMIB96MBWx3rAOuNtruL+mdEsH0NTEdyGVVhLevJGMKFBIasTuG/CPQ+ck/+vW+MrtoTlHz/h5zfpIEZX2LSVDJLs2FqLVfjHkO3Fu7NOTtQD+m4B2lkkhmQBSY7ETNPTzxg4zc8Z+umP7XTiiayTMeHcq8zPSuTyH5S7W9Zpkl9uFMfin1wkNf8lA9aNel61d7uDdPI6o1WyHSG8SRBofzi4JeD21ryZW2ak6z+W68SjDO51rq4M3JXnmFhElDIqlj7VoeszHdOMINbqgu63y1hqztZf2qHx/VQcIFLIZ2DKKoyKl4SheYaV5h4/vWKbAkhJOREO0AW/jqQJ17XIrSXy6LE6nW1rvdiEV+b6fldJWGWC1/o7B9ybtq9MVNdSZ4HEJzHNqRpjZEbj1p+sMDh+wGJcsOwr4yP6IKCigLZUIUXkTgnJF/UtsZ/3F+CyAxKUrStgw3N4XByp8Gd4JTgGPQidOwZyDzr6j0Dmwvj64TLP0Y8CcGmE5IGRPQBVZNpfr9JQ+uMldEKxcDU42MTxolbblH/MbLJoJ4Uhz6yYrzylJ7wv2DbJgUi+1rhGm0uNVgS1tyTJshoQmF2xtZaoIIK/3mehKWuyAK0gvR3trTk1vDgpVrgUd/67jGGsWv6lYnMrne/QhNJMADolgLom5qHM+1zVxK0aSpltaCzN/XaIBtgXKWKo6V9+tbtEI/kGJusm9Lsr6UaXD0XXkGh8tCTifb2n5gaYJcgnL1OWdchjKcnIwsrcZb/fYjxViKbZEtWR9ygimSkN631NBwMhLLKPNfHS757x8RHrn3LSPYMzgU2ReNXvrkVUVy43PodSVlgu6yKTk7obz2qJLXomrSfh4FMir6jLTzrZl5FdbevaxuE+2P7ClahQKVfKIk8tt0/T3atq0TPJBBMnBEqKk02KV+xh9vvViP0
 ySxifz9O
 WccLwVH7tKNN9hFwD8PAscpEAe3Hnrbo+0W5SlZr/WzdhpykCBVQ2q0VfSuGNfAcLpJtGFPooi2KKwjOi9v9u1BysEc39IkCpa1oh9GTDEuaajAN1OkXgJj3jdXL8naW/6L64gOnTJ1KibF8EioWROSMLCo8qo3PUyMKLv8s+Lr9OTlzzYu9u5DrH/QrodA6xpeMjjiE4voPWfeZKsbIjqyXuerpOMiUDBNtYLHRfxArHcpMNrkNfrIdDgRmV2UWXhTuuJSiIDvw4r90seQjkuj9J3eeH1K8hNe6smEZHsI1whBXuiXAFKTVocnh9+wi0vHWCnv2Yy8wPs8l1qFsRxuuhun8gjYjn9gH8EquzbHB4yP8DapI1NBwA++kku64ZkMuNqak5BJhHlOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Uladzislau,

> so we forbid zero as value to use?

Yes, that works as well. The parameter is 0444, so the clamp in
kvfree_rcu_init() covers every case, and with a delay of at least one
jiffy queue_delayed_work() arms a timer instead of queueing the work
under krcp->lock. The check added to run_page_cache_worker() would
then not be needed.

Thanks,
Zhan Xusheng

