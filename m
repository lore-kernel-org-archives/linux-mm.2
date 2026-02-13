Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57020EEA853
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 00:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC83B6B0005; Thu, 12 Feb 2026 19:41:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F2D6B0089; Thu, 12 Feb 2026 19:41:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5606B008A; Thu, 12 Feb 2026 19:41:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9AE6B6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:41:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 453991A019B
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:41:42 +0000 (UTC)
X-FDA: 84437580444.28.690994A
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5805E18000F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:41:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A7HcBs7f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770943300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwqSI1RFCMIyBtnekhVRj3/LtP3LLhrY9w2W+ftU2B8=;
	b=fXTDXxNZQurmhVrfmWw67PxxeVBj4Qd+R783q1AXWFy9yfncKQPRqz9DTjY4cSGkHpLQG+
	Gxi5jWyFYWzk6d65OEiIJwLDAt2+27kCVphgx/IIHGVEsu6i+NaxN60l7y+sB/DbZmWcGk
	I6rpkoudjyj9hibnam/J4rnDcdMzdQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770943300; a=rsa-sha256;
	cv=none;
	b=YjPwEaaXUodrC/pTI9zyeHVlsmbkdfFeXMrJyYRRAlvOwHVHJYl2wQKaGRYOBt1Y98J0z/
	JYjjR6D6iTQBiXEbJKmmzHdYpanXg361B//lhnEHWbe1pwgtBqbwHBGO8JzbDyLQ/7bGyW
	eZ307HkovWiw37wwQuYk+KKgw50FnDk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A7HcBs7f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2ba9c484e5eso445771eec.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770943299; x=1771548099; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DwqSI1RFCMIyBtnekhVRj3/LtP3LLhrY9w2W+ftU2B8=;
        b=A7HcBs7fHF1Eicv3U5yfYRUqladVSKCj8ihmgUS7jjT3H1DuaXj/riqwquK9D5fyd4
         zKqxu6qZGCs22NEoL2V+XhHbIuPnyA/xVt3b9fjIND5rkOw6NSv/h+B/4bEPL0C1oVo1
         +QUjP80G7GZ7sR9LuFMPUB/NwN0loRuA1ke1Imrx3uaVHAU5oHRgQTAuxKVj5YSKjQIn
         wNFW4ubPm9higg3kaCQCVf0HIkYYvEPTYIhJidBoAUSs2q/JjdI0lWvlNmW3A6c/SsjI
         Ud9cRvgOVWYOQzZU7T6DGX9hZb8eQRnv44iBSHOqBzos2XcuE1TjXkZT3W85fFboHnDW
         Rq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770943299; x=1771548099;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DwqSI1RFCMIyBtnekhVRj3/LtP3LLhrY9w2W+ftU2B8=;
        b=Wju/lrf8k5Z2bkoEBiOVQUj9zC+ggoLUcwjbBQSXsXmFCccX7JkKcad6vPPIGNC6E8
         cnRT6NMNB3fJDsT/8j7TYqDjSbi5ATSFIF6fJJLlmEMEBdqIODiCFVFmo4ufXS2iiE6f
         92YEvDec7FW9koasMGr64nv4PbPqkmFNfF9MkFDCzIudxq1rHQICa8BpjXkXaWnXKjY1
         0kHXTYSAx4bFx2Jpt7n7VZkk67MGbu8V7wCmXSQz2V4t0paidI4lBm0xHqYp3AYglG1t
         fHLoOWNL+Ni4WwH6QXvf4/rwP8bmIUM7ItcnwJynxeA8aTiFy3lSTOxHolyJ3jJjqE0x
         kRew==
X-Forwarded-Encrypted: i=1; AJvYcCVSy7ujWvTnOak2karuVOK3qGC0MlODhAncRqkXQjE9PpWCqqUVrHV8aquZTNEgsulQd1ARd+HdRg==@kvack.org
X-Gm-Message-State: AOJu0YzmHrVJsfI5eg9uwGlREYoRYAhqs6MOsn7WCp6fn6PX/QxmRJtS
	6hW0jPpZaEqUNpMJMNZ32zoYeC6B5mMmJYBwSwAsfrde/ytDjbNzWldZ
X-Gm-Gg: AZuq6aJYzILVxeBv3MACu036l5m5dMzpRtc5d7BkAl0ZRLOL+QbtbsY8ffJslMXLR6k
	5FCLqjLMnWMyGAd83heFMwkJfo9lwrrnf4p2XaGVnznxxadRn54P3dOHcqztyTH1mC2N8ki+JsF
	755Lt7akzr2PtFm1jt4lxLy2pxZytZQQ83vYECyYizQfnoJH/Jbo99a+IwK8YWjtBrL8xnwYSl4
	QnTKC2klOcAdary/xAc9ONXy25T+HHYrD7D6ncldO7X5BJ7jbAauwLw60eLwzlUXzjh+p0OVG2u
	nL1r2RdJMf7QQ3kRgW3cYotXJ/iWIYnM5QOl1TGqGlyhVRiBWqF+PpL22wWmYU8otlweZVTRNnI
	KCHGcMNdwhKhTQdgoW3yoRpmY8R7wV80Kra1GrUS0/R7OKhomJvI1exDP9w8tSrsBKFpJNjxib6
	hCIaydXhsazjXGLcm8Ug4PhcjtdVx0arbl
X-Received: by 2002:a05:7300:ca4:b0:2b7:857:db6a with SMTP id 5a478bee46e88-2babc47cb8amr28835eec.21.1770943298947;
        Thu, 12 Feb 2026 16:41:38 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dcd0609sm5409175eec.16.2026.02.12.16.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 16:41:38 -0800 (PST)
Message-ID: <f587b319-fc6c-44f5-94b0-350c1aadaa3c@gmail.com>
Date: Thu, 12 Feb 2026 16:41:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Skip test_kmem when
 cgroup.memory=nokmem
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
 <2f6ee1db173b67a636b2caa85744cb4ce8114e64.1770883926.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
In-Reply-To: <2f6ee1db173b67a636b2caa85744cb4ce8114e64.1770883926.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5805E18000F
X-Stat-Signature: gsycjeh6esyxw9955rccbtecbrra4z6d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770943300-761920
X-HE-Meta: U2FsdGVkX1+9lS3/YiRTrDkxK5Rr0gkNW4IHPlOLRxtV34g2+EBvYFWT7yt47v1riYhwvJFjTZXCBHqNm/BzZAP3Zjh6vD+m4/g2panuE3+aNMn2z4KQq9ksNLkBhn3xAhoIjn/rdJhhaD2C8za2JzhaKyYY7wAVap2dxn12HOX2IIN1tWs9tEJAu62qkGiCy4yh50zxRVWRm/rTbVDf+Phv5xuwPw8IZ6vBlMhwaQ/lSP+8LOG7UrXdQpf03Q+hVY0YkB2ho+AN1TP5aze2Ab49g3Uwru9E+FIt2Kl77Aw0ZVIjFcw0Mx6KG6EgM9aGaqZwrYNnbWZCc+UnL8RNkUUHUij37M34zf27XTjhbz7+U8/6xUKKDy5SO7gT8Bk8mTx/XNKpTq0LeW/f4LWgfZgJFzYx3y4w6myvXDrq9/VGtwLuZ4qPW1tIQfmBs4fCRrQ6t7KYCnG4yApPAq/WBTO+XzXLNM3TUEM/FFDe5nPYVlFT1LqCLp2widatra8BLs720Q03sU07in3S/AoMaW8NXAveOVV8q3VqAVf2dy2QpdYG5ImhbulcPrNj4gihgCPtyPbsi8RUd/OiCQCCD8R+SFnhyM06jM4eMrJTkvRf4v0ldjrLG9aY7d4W9XVylszR66srwwDat6Wwz0qb3ySrzJF68YAm9ju8WymHygSR77geRET6i4112lSLEEYQ6Vlqa7w9zjaAdWXO61uetp5KsDG7m5d+FwZjX213HhlKRHeAIXK2sQ0cQlLz8eT9c8aut7D/Zzxvt15AT7OIJE3QQyfU7p6RhM+BFKdEuLZZqNLA3TelpgIpz9z0PGgfKtriCiewWM1u8xXv8uLPmCStOgjpt/TKnSM4UZx1MYa0/Nzb5y5KR0anOh2X6OyJkZo/UazHkSkOSD2nmTIe/M+g+rYXMQd0VcDH5ojG6C0ViPake1rCF8GQFo71WTR09iHlAp0nGc+3uj1CwXh
 0Q7ZVRUK
 3T0wP0XVLKdzr4LN5oe4Ab46n/PiCOvGK4ycxKhY3v19Wg6gfcaBvRpTPROYSehrOQUrR/b7C9ZxQrBvYshw9e7BvhgNMgarRta0TDyG+G9ALRxP+BoqywRXUpB/gN4HMZnCxQNUGrmqfc+PLEkVRVbCYs4Gxvu4pYd6Uh5TEjsB3+QLuGnd9FrFogBA3Y0w5zd2VIl51Khqf4k2Wn2CQp7WdfVFIdmzet7S90FOFQeKEWelLjaLVU/DXAj4RWzpXiAknEy7+JGKyK6wx7n9cXvlBPfqEhmGoLgoebL7sEC4uPPF7rHy6HpdTXbqaBiLXIgcRcwVBG0Gx+HAe9qYs8fm1uZfXmYDOFb4lLdr/ap/G3Wf4Z5FUdHWPLQAIoHXd9TAcZE7SkDCr42Fi+iTs1j4HneTK3NA2DThODWJS2GWxhfvHaHsK5yjoKx68dwngsaUuRJScdWju4EG6az0A9FqblaLZ6bNN8XavSwe6qiuUhV8hTJqhkpFd8nP4KMOzVXXFdx2otLo5RWTHyQzrHqPsVxn+PBI//wurZ6xC26ZdLrPe5okIIUkXpg==
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
> When cgroup.memory=nokmem is set in kernel command line, kmem
> accounting is disabled and the test_kmem subtest will fail.
> 
> Add a check to skip this test when the parameter is present.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>   .../bpf/prog_tests/cgroup_iter_memcg.c        | 28 +++++++++++++++++++
>   1 file changed, 28 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> index 13b299512429..203e6b091a21 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> @@ -134,11 +134,39 @@ static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
>   	shm_unlink("/tmp_shmem");
>   }
>   
> +static bool cmdline_has(const char *arg)
> +{
> +	char cmdline[4096];
> +	int fd;
> +	ssize_t len;
> +	bool ret = false;
> +
> +	fd = open("/proc/cmdline", O_RDONLY);
> +	if (fd < 0)
> +		return false;
> +
> +	len = read(fd, cmdline, sizeof(cmdline) - 1);
> +	close(fd);
> +	if (len < 0)
> +		return false;
> +
> +	cmdline[len] = '\0';
> +	if (strstr(cmdline, arg))
> +		ret = true;
> +
> +	return ret;
> +}
> +
>   #define NR_PIPES 64
>   static void test_kmem(struct bpf_link *link, struct memcg_query *memcg_query)
>   {
>   	int fds[NR_PIPES][2], i;
>   
> +	if (cmdline_has("cgroup.memory=nokmem")) {
> +		test__skip();
> +		return;
> +	}

Instead of just skipping what if we proceed and then confirm we get a
zero value after the allocations?

