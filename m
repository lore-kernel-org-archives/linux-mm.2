Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B6AFEEA86E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 00:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64FAA6B0005; Thu, 12 Feb 2026 19:39:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD546B0089; Thu, 12 Feb 2026 19:39:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF696B008A; Thu, 12 Feb 2026 19:39:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5BF6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:39:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D805D58577
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:38:59 +0000 (UTC)
X-FDA: 84437573598.18.2D67DE0
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id E7374A000D
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:38:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EC4NwuSb;
	spf=pass (imf25.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770943138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lp9040amXhpFPWQBTbbqsO5bbDZPitD7bxgNCwcTcG0=;
	b=CqtIxl+WoGC2G0N4adKQzyArORWFiiBdlfqBgayEckmfmRI2MQZlMkD2uiu6s6is0gG3i2
	wZUXTBoglmYcDUjTO1BA2wY2LpytqRNrKsDefspyxqDkJRfng6kvIafdVBhDgvVFw8pQJ7
	F3q6+TMBqBbldEazKCVfjFUPFFZmabE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EC4NwuSb;
	spf=pass (imf25.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770943138; a=rsa-sha256;
	cv=none;
	b=M+jWJ5D2dO5GrrFlqafeOq36dOIX6UD/ufx8hvcGoEPCw1jUvOZa/BgVvf5DPcRIzIxlLy
	YRgU9o8JIcDT3ngdpFWfIFgKfW6HS5hG3XKW5aQ44YjUjFja+0X5tBgMrLlqeFXb5ylwJ9
	WRa5MO0Zf9W/jqp2FIxVykcEhDWh0Ng=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1270ac5d3efso475376c88.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770943137; x=1771547937; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lp9040amXhpFPWQBTbbqsO5bbDZPitD7bxgNCwcTcG0=;
        b=EC4NwuSb4Bc2LOOn0K+WW3aSsnFQQxD6cLs7+rAs8pLF9imUSdD4BRFUMt1zIofWbo
         dVJ0gGq6VhG2YbRtlIK4whfwKf9vffHh3J1YUdJVUY5lXk1AYRzQgAglpmjLNzIMqn6r
         XYunBSmQK+L6QraIKeacO4OtdnUiRPrtp/1xDE8yqXbo/u3TX8XyMEKhV5WZ8LMblIJD
         DklOjS9D45ggheAF8kJw8T7rk7i3ZC+hDPMXPacH/6NaXwjKaJnefmZoecynLzzuizoO
         El4iq2onWHSPi8gYyeUZU93eLSK22s6KEvrB4LRu8gJbo9NSUSENi55SswcrPRKMvmZf
         AruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770943137; x=1771547937;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lp9040amXhpFPWQBTbbqsO5bbDZPitD7bxgNCwcTcG0=;
        b=vBMmobRqKUqFJPVTpF141Z7M6wLhO6Zr62eLrhJe8Ej7pj9TpwotLDdEn+06CjAao8
         AL5ORF8RHt9+w2wrB+oGOhHGD85TainyJTFXBOVcsYccQGK7b7fgXXxJevv11jMlASRV
         LXAdKMuNuAaIidcExDpZk6cc3ZyLRPKcSmXtfFo4zNwVOuTOXeXgYn7iV8r7UYDgiqLu
         lMjcmPTcQUI+mqKYA7Jo27aTNLLTGe9jKQ0NbxGwbsucB16j9k68qt+P1jz+4y7K0G+M
         PHcIxJ+PtZHzkaav5pHsv+TyHRdJXAvrE0j0098k8YNbsngNs8MPTk9NMy9XjxhCGlH9
         fduw==
X-Forwarded-Encrypted: i=1; AJvYcCVcodU1lzthpxSRMhI0KdqShgsLLZ/TGQ0oFFOEv45vJRayhUwBMojG7k4BkrHyGOzVPsNSRUaVtw==@kvack.org
X-Gm-Message-State: AOJu0Yww8HQph6+Tzq/QhgBLbGBBywri2pIRhz43JvJDxL+NcBPuZFzy
	F5WkzvRptocse6gJB8ylIlTIlZ4fIKWN2Wnxm0wDrKC7pkZTSgLo3jPE
X-Gm-Gg: AZuq6aKwL2OsgHpGjpHwk//63Q4TP7zxLIk+Sg2JR4GIyW1D5gvg/TEWsSNA8Wu28di
	Ke2o2+SGyp09BZdr1LstiXEd4u3GsMwMwZHA1r2XWaIJmUaXoJdA4WRHbFY2EfigoqAS68pH4dy
	oHhMY/Nn4UI12XuuDSbphzBZRb0eyv2LNJa2NbMvRwxKMiOErR5xFT8fIgU0LVEKToC8xGgApY6
	G4DusWfgit2HIxdvL04Z13Yp+IaqeIgbmCzSdVCWgzRnmyBdhyc/Ydlhq1n1A3fwEoUKD5PreLf
	fZ2qxL3S79diw967M51qs698TKNVOp1zX0yqglLnNNk50z9WYCfcHm+Bb20KCjXCBESePPJxwbg
	iQ/MJ2ztewWqO6OsUqwAZoUo7ruMbTqoW+LE2B3DrHpXsjplSTqjcyw7MYEYh/ESP9mzI5fpGcJ
	C9KxSxSMfjs5NGZz/Om/Dxzdx2fIcv85uzV81tKdXBGG4=
X-Received: by 2002:a05:693c:2b06:b0:2ba:75f5:72a2 with SMTP id 5a478bee46e88-2babc3a4e2emr44150eec.2.1770943136554;
        Thu, 12 Feb 2026 16:38:56 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dcd00d2sm5059384eec.20.2026.02.12.16.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 16:38:56 -0800 (PST)
Message-ID: <51bbd728-c712-4601-8a4a-7c602c67fe75@gmail.com>
Date: Thu, 12 Feb 2026 16:38:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next 2/3] mm/memcontrol: Return error when accessing
 kmem with nokmem
To: Hui Zhu <hui.zhu@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Hui Zhu <zhuhui@kylinos.cn>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <cover.1770883926.git.zhuhui@kylinos.cn>
 <733422f72ccbac94126ae67b9e49f4a3d460b76a.1770883926.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
In-Reply-To: <733422f72ccbac94126ae67b9e49f4a3d460b76a.1770883926.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: un5t3ejyokw5kh7ssmiooak64hnqm584
X-Rspamd-Queue-Id: E7374A000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770943137-490860
X-HE-Meta: U2FsdGVkX18aWxQME06DX5ASVudmzW9QTxn/qT3rEUT0ha9pI+T7DYHkkMyZAEX2UbE4r8WfJZ63toVlWTQs2fFz3jbbh1KZYKLcFvQit/dXMe6QS5HD08JOpSqNpEndcsQms6OwbuSqq+8zKJtILlX9bJbYW7mePzU9b785MmiBwSpYSgZFn7YtYuxfWYTiU9aZcgbcOzNPvquZkf0LX2Af2TsVQle5m+ndTpRiu0YylRG7HrZbUfaVEDzIbpehtwT3JHAt1sw6i1rg2Gxb1FcoHTY+TLX/qRZ9iX7kly8vpO6KVMgDLgnP4/KPxd7mVUHndQay1YJphqDVv2JyMl43lFBS30vDUBOcV8MWApqQ5VqOWEPnu0NsDh0CB2xOHnQWg/apkMgfP5eew9gzMq4qUOKrc9gVm0NSmWB0INcUGFrTXV+NeomL14OmRRGHZe74y8k17zkGOW2vNf1FH719HLRpMIIpGDcU9/d0EMYrAURmq/+XV8KUobjNNUlpNFeFSrF8pm8+KAIvjEwBh2wepqfnWs6tgmGWtyXBc9B3jAou8z6tcCeiCTzHQ3rhzKXlP5reWhZ5RPd+aU3sGJP7vAdVRrawx9WNpusQiHgaL2VqwYtRMQRy/lAgJu8nb6zDhfpFqFfZYm30OvQgbuhTv+YKRUcfnuFhL4SZ6v0sbJzIz4aLA+5lHEcmlPnIBdktSSGpP6L+gQDZjR3caLrGFKSVW7o+8kaUaruX8eu4xxDedo6Jx2CivCkVZOV0pVu+51qnRngN8NZQDyQfhV9m3FwZ+SiJzEY4ezigRrIamIeIKO/JzyQmwniinWEVC+QvibOOeXqsSR2+F+X/IA0MqlOJQ+YhUoOUEYA+KxXFWqRhrqtWFqx1yiOFTCezn/F6MEKvNwLnNq4tv5YsXE1ehivoS8B3/jDVk/vr57wQUV4g+E/UbyFagZtjiv7f3U7VC8PMGJxlYLySrud
 JhmPcs25
 UfawVn6iLAi/TCR5NqkeGRuPGI2N7lEoWiOXRg7KTmBu6qBct5TOz35jvTeHobg2sWizaVt7At69p0/9L5qGQmSDMe69MhreWiCSXjkNmDq972wK8rYglh27u+icyvmH9unrheC0rwCImCPqxdlqn3xxFBZWf/NZalyECMFZVFnQ7jXihIt2hIdKNQfKi9eyEN35Fc6ZFDkVEpHYj2XBwi+JP1ppU+vdFGTHzdiXqH+zrIL1KssYT1fv/7NlVoqL2Z0qZqVuf3NFfoNS2cAi3tS3REi2iUz/Y4u7GBMnkhnVU0ca60a/hLOqdozLCi2IY0NE5dX4NS12U2Ae1G2dnNAHoaG9NvUzdqcCoT/d21bTTlqjAP/m0z1vvS/+GnWiZzK+N4dwyMicLjZnCMyDPdLV+trBwdV0FSZ24v6RUnMQLayBIQ6DyK1h9iYYAkc1+6IYVavy0Sq2w7zvNUQLBNL5mEbCS1Q7l9YxC9wjfna4vYHFuzWUHwWKkjzCqgHbTKo0Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 12:23 AM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> When running tests on hosts with cgroup.memory=nokmem enabled for
> performance reasons, test_kmem always gets a value of 0 for kmem
> statistics.
> 
> Since BPF programs cannot easily determine whether kmem is enabled,
> add a check in memcg_stat_item_valid() to return an error when
> attempting to access MEMCG_KMEM statistics while kmem accounting
> is disabled via cgroup_memory_nokmem.
> 
> This prevents BPF programs from silently receiving zero values and
> allows them to properly handle the case where kmem accounting is
> unavailable.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>   mm/memcontrol.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 129eed3ff5bb..4d8419623d1c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -667,7 +667,8 @@ unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
>   
>   bool memcg_stat_item_valid(int idx)
>   {
> -	if ((u32)idx >= MEMCG_NR_STAT)
> +	if ((u32)idx >= MEMCG_NR_STAT ||
> +	    (cgroup_memory_nokmem && (u32)idx == MEMCG_KMEM))
>   		return false;

It's still a valid stat though, right? When it's disabled the value will
just remain zero. I don't think this is necessary.

