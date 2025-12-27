Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D48E92717
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 17:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CE36B0005; Sat, 27 Dec 2025 12:50:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A4A6B0089; Sat, 27 Dec 2025 12:50:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE29E6B008A; Sat, 27 Dec 2025 12:50:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEBE26B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 12:50:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5930AD0832
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 17:50:32 +0000 (UTC)
X-FDA: 84265990704.23.AB20E3D
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D898180002
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 17:50:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NGrXvy+p;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766857830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WL14hCGzkiqmAvKmCU+thkeYezwIsMSVDEfVrt3GJis=;
	b=n5p8K6MXftS8vPGDCJpJBJatPA/wMUGed5M851pdVdRGdHfV0BsWwYtkeC3KpBCV4rJhK5
	gz1YeOMjJbh8i5nSpUEf8qpW69VPOIdLkzejCsQpPJUY7ThNVmFbvzsc+YGi+c1eb+IxcX
	8ULVynKeBCgUHlbtMjq4XYzxRcNiFnE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NGrXvy+p;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766857830; a=rsa-sha256;
	cv=none;
	b=hlheXzxFQ5e0/XPYKKoCGMXy4jWJ83qzLESih0wiW+6i2w6vQczcg6LGJtxpgrIQJ3z33M
	xMJ3250SJB9c61auwqPUVHc4qU2QbCAr9hZzBV/a0uGIyye9AgEVRAIcto5i+O9MBMIAzO
	ixg5T2wpbYl7Wu1ojYB0IUsfL+Kxa0E=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b79af62d36bso1372879466b.3
        for <linux-mm@kvack.org>; Sat, 27 Dec 2025 09:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766857829; x=1767462629; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WL14hCGzkiqmAvKmCU+thkeYezwIsMSVDEfVrt3GJis=;
        b=NGrXvy+pplTX/w8FoZlyb0JGKZlKfEcwTsmXGM4wF+eIwS7MaRkT1WobKA9RAljsKN
         JIHomGcZojhVo4fU4a3X1XgcgLHVJefGYGfrJWy+cPQnB7c6zPupqTPqm3Yshhe3iqg6
         GrP0XDuJCHMW4QJgmulQM3t4ccrjDrzmmAjETEj5oPkOkP8NZVygRV3k+dE3+7I4+vuZ
         taj0FqGtpHKR2LAhLXKjAw+KEC4UCGEGai6xedHysQ9ciTnQAxXNIOlUO7x1dhw+4yvV
         FkGJNKzzFw+QDN41AfPFmFJQ3j8zkmfeW6mI3Kibgqg+eKHSBVmrgLzZQ3j5G+5QscKZ
         jIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766857829; x=1767462629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WL14hCGzkiqmAvKmCU+thkeYezwIsMSVDEfVrt3GJis=;
        b=BB63txASN2HnhSdrmtQkuE0N5H2IoZoYrIUxwdJUupj9qW/l1889GHClPxbZGyugb3
         kgcE1sWtxc6UpZv2lmChMe70ypnTUnOqgm+kB+lrkbpjbNUcoNQPlWK+UcoqYwFxSZwN
         8/Z74i2zTEcZdjoehrPkFIecpgtYkNcMc6me/MZnyYfXDRTNZ5QKGe4BCb4ILErapJJ4
         DsmoUgvhYuyzksenMr4ci715DaJjWF003NzU4qGywQVRB/57DwV0rIEmBWGI8+8B4hkz
         ITvQwQ2/szj5tuz0om965o7Tr/ehDrSVMMxct9ineOgeeJkd2R8IyvMHUrYMljpuXFEe
         10jA==
X-Forwarded-Encrypted: i=1; AJvYcCUa0+Uo+LFub7OX0E0PYVvw/eiS43pWV/6su/kdcyHi6UwGhw6Qzk7y6vP2Td8eEw+yOOw/jCVtIg==@kvack.org
X-Gm-Message-State: AOJu0Yz2D2tsTr1HFj5iZKLM70iUtlN2XxwXQWGzPniWYwzP26QAjTM3
	l/fGanmPUstpdEsQ8RM7rrC3/61OyMak2C/YaJ6CZZvKKR/07hjEKXn+1VBw0nX8m9Eb/FIZNEA
	AxrY9XdFB/mQmNqYuOU1oUaPpE/K2U/Q=
X-Gm-Gg: AY/fxX6GshWbVtMldT6ojcBGQ77tV1BbRENqgUUV3bBA2SgQdxCEeMJu8JLhULbCT8m
	fF6ZeZdfAK9SFhxRBEXlfdeKaCDDPwek40d8KfNEjptqU4isEDESsSbh1PvUezmnOTpXR9dln5p
	IWsguYDobwxsPmCwCWhTgpU6u2n/kxHZcZAoL55olmExiGyTryzzzz8jSwWWtpBOCeLQ1f47J+8
	Rv+LS9nbkoaRsJ0GcfUi11SCibsC2GXLiCkN/6W4PadPT6KGXMpLOHtstnuHr7b9PUacvtBdchM
	oy8UPjBcRqJVOPPqBq9Bx/P8iYOAMiJR
X-Google-Smtp-Source: AGHT+IEZgbvqTOYwo3FJJfnfUezy6+2cWZ9EeFPcolMCxdO4EgAtFxeH9qjjcUEpdcjraPKWzcZMdilgj0ntgRU/07g=
X-Received: by 2002:a17:907:829a:b0:b83:246c:d125 with SMTP id
 a640c23a62f3a-b83246cd206mr560818966b.41.1766857828401; Sat, 27 Dec 2025
 09:50:28 -0800 (PST)
MIME-Version: 1.0
References: <20251224073032.161911-1-chenridong@huaweicloud.com>
In-Reply-To: <20251224073032.161911-1-chenridong@huaweicloud.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 28 Dec 2025 01:49:50 +0800
X-Gm-Features: AQt7F2rOR-WeID-Ov1CqYlda8yYcBaRSvHcd5dFl0LZVdgzXP8wohTfuzaZzioI
Message-ID: <CAMgjq7DQmdoQKZeFjpnYQ4wgMx3j-Lu7na+Ghs_Dh=Rq36MDOw@mail.gmail.com>
Subject: Re: [PATCH -next v2 0/7] mm/mglru: remove memcg lru
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, zhengqi.arch@bytedance.com, 
	mkoutny@suse.com, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lujialin4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: opqs98doxusmji5ckjinjmp6xq9aaory
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D898180002
X-HE-Tag: 1766857830-914080
X-HE-Meta: U2FsdGVkX1+tkszGrPqN28HcLO6qVNj7EjSdDSG2mPqRnDUAwH68GVfZQrq4t7g4oTWT8G0xriKXuuXtnfPx36TQbZSihRUXfcCzLhc09BjHfQY3FpvdFBPWDjXibg/jsmlx30rWgsuthBAmAzOMj1D2byvu3aXHQTRBf2GzMYVQ1EO206Zo1FRD1+Fdd123+jKr7klqjr8846GY3nDRQHXapo53zvy6qyr0YQd/2Yz67Na6RGRXS/ONKEnndSCuEN4D9AIZ840J17EbASdOOaM7AtxsvluPjZMfIci7/9S/2RsgI4riI3TEQ9oyD1DcgghDlyn7PC9EKNUpn6viMqz29zHdcVXnd+4SoB31MvKaNMlePxsT8onPrYXlRX3oDs+3YzNjP7NnrAW4zObziObBt8lJNUiJAVrn2bq73CKgb5JpE7wUJHU6Bd7O+HxuHcyqoDQkpakZXGHOJUyqj/j9MW8oqBrd0hkNknXLHzrYNo1TX4rMT6GR8QNqtS0IkhKBDLA53Ovxe0HtNhAfSn7pOmaagXo9YD5RQ2nMwPdTjp/4Fw0KO6HiDMMdEFiq5hSsR8K5cPExQBGVcPW2nUYORq1410DoJRtZUkMp07ABRQ7KIoQ3wLnDpw4D4cGaeCzLKzf3TdGc2rHHcoL+cptOuZPPNp+SCWGt6HQzyfkwEo6Dg6dqTFvHIjobPSFBsT90I1bqKo5A6pp7iyQlx3p3nTUXhVieeRj5qGaNdm68ALxbADdcCXIJ/rX4BGL+nRdU074Vk0B/yU1TR8huO7wESTKsbLe6Bb1moB7oJ+L4XGNA7hHA8FsUQ7kIJxVgMBOvFDbA15vrZzR9N7VCiXa3YYtBlObIrMIm93/WWuAo3jzU9IMhfwE/74LesLMHnW059g7080uesP37diPU+m465phsw0uOevw+JUKlVs+GI8iaum2tjn3uATeqbXgDgeAIlDDbG/eSIUEgGJa
 +MJdE+4b
 p+ZM3rBZatFvcVFF7FhW4gsuD5zQPdt2zvkfr/IjZxeQ5ZE30fG38qyOUYmR4YH93929txgwh1dmq5oIgAtmFSizpLK3KTPKP0CLVgJ6rvqBy0sapa94Eu7cs1JkBhK+eCOo0UHbFT7wQtJ8jnq5yl9a2hkVVL3an8GYUsZjbLiC88lqyqKyiBeKZDgdWFEw3o4L+nrwYRa4sVo/v/hb1VlGMOYmri1yXAetWB5As4J7vVAWMXDKFQTOoL15Wlu2YoQgrZOAR1pon1wG+VnPdB1kxZy9rF2JnKgHSldS0q0ITiQmSKnpzr/vgmyDaI3TIVq07NKGs29FX2yWKSuAoVLlU9jus4iv+zgTvYt9+uF+2bTPSMwGyQzRmh8Wilsg5et4fNXvLT2WGQb5RYIvQJnY9T/3fYKPaNc9UeDa8lceOw2El7WKfSkqAb/SGwVp1UZsvRMP4WfnQsPFJKVC5eiG7UTeiU18qGUlXnlTMg+0iYyAoDKm/Wmpl9IpSMWe49qytgrisJoeVc3uMql5O0B80BswuWiWsO6zj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 3:56=E2=80=AFPM Chen Ridong <chenridong@huaweicloud=
.com> wrote:
>
> From: Chen Ridong <chenridong@huawei.com>
>
> The memcg LRU was introduced to improve scalability in global reclaim,
> but its implementation has grown complex and can cause performance
> regressions when creating many memory cgroups [1].
>
> This series implements mem_cgroup_iter with a reclaim cookie in
> shrink_many() for global reclaim, following the pattern already used in
> shrink_node_memcgs(), an approach suggested by Johannes [1]. The new
> design maintains good fairness across cgroups by preserving iteration
> state between reclaim passes.
>
> Testing was performed using the original stress test from Yu Zhao [2] on =
a
> 1 TB, 4-node NUMA system. The results show:
>
>     pgsteal:
>                                         memcg LRU    memcg iter
>     stddev(pgsteal) / mean(pgsteal)     106.03%       93.20%
>     sum(pgsteal) / sum(requested)        98.10%       99.28%
>
>     workingset_refault_anon:
>                                         memcg LRU    memcg iter
>     stddev(refault) / mean(refault)     193.97%      134.67%
>     sum(refault)                       1,963,229    2,027,567

Hi Ridong,

Thanks for helping simplify the code, I would also like to see it get simpl=
er.

But refault isn't what the memcg LRU is trying to prevent, memcg LRU
is intended to reduce the overhead of reclaim. If there are multiple
memcg running, the memcg LRU helps to scale up and reclaim the least
reclaimed one and hence reduce the total system time spent on
eviction.

That test you used was only posted to show that memcg LRU is
effective. The scalability test is posted elsewhere, both from Yu:
https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/
https://lore.kernel.org/all/20221221000748.1374772-1-yuzhao@google.com/

I'm not entirely sure the performance impact of this series on that,
but I think this test postes here doesn't really prove that. Just my
two cents.

