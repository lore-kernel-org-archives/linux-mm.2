Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1064F4369B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215ED6B00FB; Fri, 17 Apr 2026 08:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED5D6B00FD; Fri, 17 Apr 2026 08:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103416B00FE; Fri, 17 Apr 2026 08:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F11C96B00FB
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:49:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD1261B6CCC
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:49:32 +0000 (UTC)
X-FDA: 84668028984.26.F5A2CFE
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7E9762000A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:49:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GOI8VT7q;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776430170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YXc6lmqdJEJYrIiZ/b+NB+dBN9OWboEsbVHUprNV5I=;
	b=yzt9r/kQc6jdG+j6kU3T5raLbzg73Lr6vzOwSROWUWnRZNMqAHGgILLrtJYibvQ2eS81e0
	T7VFr9NQvY8Ahm1cfTsZrAG2ETg+G8qZGSeRxC8Cy8eNfrJ4EljUvuhdtWcuw8owhTqxwa
	7LDZDnjP1SPtCqACp7yEGpuSWD2BD5o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776430170; a=rsa-sha256;
	cv=pass;
	b=59yXSajNSUWsu5e4vbe7ddJOo/mOMsk20en4/Uh+JQXzC3uaqd0UtMVIq2RNv0BcE2BbS6
	v6i709t/tc4NlnEqYjYQHagR40T/JjjuaLpEb3NRbXNOKSOaq5cM+p+Dsth9RslJwTvu81
	FKVw+UDY1m2iYgp3NxCW5/+yVoKgxzI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GOI8VT7q;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7b41fdf9de2so4240017b3.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:49:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776430169; cv=none;
        d=google.com; s=arc-20240605;
        b=NFJiER7FscMjKJYiOjof0jpsC+D4Eo5cAvlql+devd8Wg7nwMbWotl7HK7HxZZvXre
         CklNb+63elukyd+aEhfLlAkEriwycAgO/nIfRSdYGE5f1jEDUu1WHn7iKMvh3SDrF1bO
         IarnSEg5BRr4VM/L/UKYBf4xv/byuCkr+L34/XUMmfAdNkwdnBkvD4YQ7Cs5dtuRxyF9
         QNp6XzGHw5pMNkaNyw1BxsJQoN7LFOYFJQYNYEpXrVbJ10wmi/uU8l7bg3aO9AjtgS6s
         y31LvLV90MgYPqJNMqayDnqF1IYNTtI7/HrZBlHkzGnjSQeWTwC9WXwS8gZ0PNuNadR3
         LHNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6YXc6lmqdJEJYrIiZ/b+NB+dBN9OWboEsbVHUprNV5I=;
        fh=PX38tVck0k1B0O5o/9FsaJj6D8pDxyavOZT6baTm6Fc=;
        b=b6V1qVpod9dFuOt2HcEUOI5W3qvel5SD4yMqdsTfefJSXg5ttwImajaIhSWQgR0Eon
         KD4UcORc99zVm+xO03IrfgG9hf9jmskkLf8oarzh18ECNQmngoGeS2kZlm4d+WR21wIZ
         InOo9PaUQ1nWl+Jz4+UEiB0FFauWwhKPbZfEOXy/XObb0dR04iu+ieJPqkmdI4t+TeLj
         99FUrwjfBgP2dnlcFHOeeuWz5TC4NuLhYXpJkjdmm1oi11LTt8eebMC2T6HoPJWbaUOT
         GiYy67P0WSC9GalHbTdSx3NKglpJVGj1YGZsJj74HY6q5emM/63qdFS6GCfWSSEydbJH
         YbQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776430169; x=1777034969; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6YXc6lmqdJEJYrIiZ/b+NB+dBN9OWboEsbVHUprNV5I=;
        b=GOI8VT7qg43ti7n644bpQxg2ShuDQVdbnq41E0vB5OIfoORrcJIykqj5GS5zRBRb9m
         wAgfnDAMUdN2RdPhLGHiCDUC6GixStDTyrS/o3H1JhelbSOYX0WQyV6MKsevK9J7bddY
         4PpX0jUpgvLjC11qZVqQQp4rVO527u9qqteJOdE7L1pae0QYxvlSYlgLAmNWgofq7zRn
         0POwGwKxqe6F6za7j/nBX96i88OVI8oURovUIK/EKFIu6dDhm72U32LI/1T+me54Owde
         ILt5J81LVEjB+IS9KZXmd+lgmy8tWeUsOrI2euS+lNv2EuRxrfNsBbBf9dzDMbF2yyy0
         dPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776430169; x=1777034969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6YXc6lmqdJEJYrIiZ/b+NB+dBN9OWboEsbVHUprNV5I=;
        b=iZiig2mmnC5G+AWeDO5tzezctSCkExMiv7gTFSU8oIIb8duCWGbswV99AEjDPA0LXc
         +Cl28QZKAxRd9VIsXsmnahRPedZjybchUU4dlxXy/aDh3/0qnTISmmJg6Cc6pDyet66u
         gK3l3XgIjD+CA9X2m3Ak+FHPEJ7++1Mxxywnu1Pah+Aes8IKjyksxeSYXm4jegyFFjRW
         iN9GK5XlfTYy7gMFHP0ygMyKAPMktsJgBNzDGh0hl3K7Q2vRZDAAI1TGbYyQIxfO9/o1
         6sIlWWyPnI/CwIUIS39OmLbBj+YKABnFr37hUK8ivX6ksiWJs2WtTztFDnFKSh1jBtG/
         JN5w==
X-Gm-Message-State: AOJu0Yz6fU+SGTydaPLZMik/CAiWvQXdSJ/woFG9tUZQ2CvgnQw+g2Ic
	ZCIDFOPdhZx9+kN2pgdewGHZKpc6lcUkofb36GEA9SgM9yRTouTPo0w/8gsddjmCXzK2IB67z3I
	Bf8bHuCdg+ut7ZSX3UR79tPFTx+0DHtQ=
X-Gm-Gg: AeBDietCF8Em6WsVJV6/sOZMvZV/CExxfNGuFW8ZFpHKP59oRz2MlRhYEaQGyVWznnz
	oR6AjrJgseYJNHNmJsN088+EGIEtC5ZquoccO3H2SjlU9p36VEcWkB2NGbUQHC/ijwzqkKaMP/F
	s/e+lrov0MzIThba8ArRJnKGgJ4hmtT49vuo6vfEjIFMOk8jkVAfAxidA1efMbjVa4xy+lWk7x1
	uDMT/DogtvDQKKegTOsluwKbDOTBzDXYzsvBxY6Gcbi5LOVy31aAaN0DfdPNOJCdemzN2JCX5eP
	NduWquVxtDs0HFY=
X-Received: by 2002:a05:690c:e3e3:b0:7af:6075:4e0e with SMTP id
 00721157ae682-7b9ecfc8de1mr26403107b3.35.1776430169349; Fri, 17 Apr 2026
 05:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260417114127.1664283-1-ekffu200098@gmail.com>
In-Reply-To: <20260417114127.1664283-1-ekffu200098@gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Fri, 17 Apr 2026 21:49:17 +0900
X-Gm-Features: AQROBzCDigaZkv_rRIZIn2wGBR5knbzDGUqVWCV3mTzxUxZsNEXrpyFtmD4oNu4
Message-ID: <CABFDxMEz2=wq_B+ck72MaskPhYpis544KuwdxWjPs43qSMPsgg@mail.gmail.com>
Subject: Re: [PATCH] mm/fake-numa: fix under-allocation detection in uniform split
To: akpm@linux-foundation.org, rppt@kernel.org, djbw@kernel.org, 
	mingo@kernel.org
Cc: linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>, 
	Munhui Chae <mochae@student.42seoul.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7E9762000A
X-Rspamd-Server: rspam07
X-Stat-Signature: gs3j386jhm5q1mn6ewssbzf97wpeysyk
X-Rspam-User: 
X-HE-Tag: 1776430170-876592
X-HE-Meta: U2FsdGVkX1+Z2St6MtGYH49D83l2T+6DzEfuagkpxQ38GQMTZyc0/kUtMdbmEv6lI6O1QOZ3D4skBThBWAGHyRPlVOYlfVNjdRQM3HeptwnAgxOMZdlmT/TFC6eS2TXUuMxXwIb3oGCa7bxF6/Q85R2FJC2iA9Je4TJeDgSHKV649DiXoCH7Yo9Mdz0ZrR0FbXSSYaREhpmJkpg3eEoZhutXibIJVHyRUBMp57DXHME/bqSrztMPp2fSmHVkqsoekGHB+B9Ii0jA41qcSWqfKaE4tj/LX4ybIfP8DRZe57lTIN71g3mxXXBeeUwp8fEWaQbU17YCm6ALJuY4Y38/O4Ia9OSjmVicT5wjtDh6VEfEnsghFX+Uki4QzALOSBFOjja9X80/s3namanrXp9c9r2d9zflT2ktwbdvp7My6kYitrueHC+a8OGTSrzAPTwrNPUj9AFWoGxTY5yVa45JIlIwgDGqMimJlYtOb9iSPjHIhOBTkjAAmYV35d40LMHspbHNMO/EOBhxbA1hlWQg1lbAT1sW3ttf04z1xgyvMAtljFhd5ow6wx4wpueF7IH9a2aHEAWCKsrcDnSBfwIUWjmYXITaI298Es0Ch77o7qVch0OKBx8cMdNp8uHAmLfgwzFKy+8nicpzPYmzKQ5rwc1dpwTKfx05Iz3XJVI25rrc0G/pqrOaIdyosKlhELz0m/h2fOGQHtTd5xjXAim6xiFizPAd7JjFkQlOLyvjCdwjCwzbnRDZGLnXFWTRxCWd+3MjiXRD7YjxYz/kIEQP2GxFMjX4eUPq4cJ057qm/UnoG+4O5V46AwC7FzEKAG1oF6wunWFnHKF5Ckt1so9vfrB1IYUIEkYb1DuP6FgYBUPVcs+WMc4rtJrFuCzaGQa0vU7ykfChJP/sZzlhITi/5AfAcYix09aZ3viUABMrnguGaZ2GVedg+0uMVOzfzNVqczKG0UGzB1niV0NmQLo
 ++DWgMuW
 lfgWbThDFbC41EUwtGq6xNDhTOTdS6PQmsmkYdXQXQjMfu7MWPGRATkul9OV48374HqX3PlAI3zao8Kx94pi0wE1XLheadU+guTg9Jzp3fAEnuyV8Gj8218FGQlvjIMvM90+eXjaAW1j9WkwfFcIRbx1xTPiwFczeTGcC45RHovxnxMwKSA/2Am7mepSeSMeu1aidtiSXJ1rd/VMvKhNCLBqlIkF9QCRXJw68tv0Boi+fSi9qVGyRk4zNpKVOYIFBvFW0LBReRlNpzrFjlxXwwynphiNfW7YCpLnizWom+YWcIwCc8prWhyugbpV5Ya7YNkzFvVTuXrQA7IUEdHLJgNDkADJaberDh4jBD+N0dNUKOsSOGlNaoZTdyZJZnw4ZpbVOZBNIDFoAE7mJbq+KAjQ4cnmayVR8HMoQRUcQSLxK3UuCAaXcgLrP3zO4UbIOeW1Csa88F66ZvH3lakz9BpPomw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 8:41=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.c=
om> wrote:
>
> When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> returns the next absolute node ID, not the number of nodes created.
>
> The existing under-allocation detection logic compares next absolute node
> ID (ret) and request count (n), which only works when nid starts at 0.
>
> For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> 1: 128MB) and numa=3Dfake=3D8U, 8 fake nodes are successfully created fro=
m
> node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> fake node nid starts at 8, but only 4 fake nodes are created due to
> current FAKE_NODE_MIN_SIZE being 32MB, and
> split_nodes_size_interleave_uniform() returns 12. By existing
> under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> under-allocation will not be detected.
>
> Fix under-allocation detection logic to compare the number of actually
> created nodes (ret - nid) against the request count (n).
>
> Also, fix the outdated comment to match the actual return value.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> Reported-by: Donghyeon Lee <asd142513@gmail.com>
> Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capabil=
ity") # 4.19
> ---
> Changes from RFC v1 [1]
> - Merge patchset into once.
> - Change base from linux-next to mm-unstable
>
> Changes from RFC v2 [2]
> - Fix error message to use the number of created node instead of
>   returned node ID.
> - Define nr_created variable to explicitly show the number of created
>   noeds.
>
> [1] https://lore.kernel.org/all/20260413154438.396031-1-ekffu200098@gmail=
.com/
> [2] https://lore.kernel.org/all/20260416102558.575210-1-ekffu200098@gmail=
.com/
> ---
> QEMU-based test results for the commit message scenario.
>
> 1) AS-IS (before fix)
> [    0.001878] NUMA: Node 0 [mem 0x00001000-0x0009ffff] + [mem 0x00100000=
-0x7fffffff] ]
> [    0.001881] Fake node size 255MB too small, increasing to 256MB
> [    0.001882] Faking node 0 at [mem 0x0000000000001000-0x0000000010000ff=
f] (256MB)
> [    0.001883] Faking node 1 at [mem 0x0000000010001000-0x0000000020000ff=
f] (256MB)
> [    0.001883] Faking node 2 at [mem 0x0000000020001000-0x0000000030000ff=
f] (256MB)
> [    0.001884] Faking node 3 at [mem 0x0000000030001000-0x0000000040000ff=
f] (256MB)
> [    0.001884] Faking node 4 at [mem 0x0000000040001000-0x0000000050000ff=
f] (256MB)
> [    0.001884] Faking node 5 at [mem 0x0000000050001000-0x0000000060000ff=
f] (256MB)
> [    0.001885] Faking node 6 at [mem 0x0000000060001000-0x0000000070000ff=
f] (256MB)
> [    0.001885] Faking node 7 at [mem 0x0000000070001000-0x000000007ffffff=
f] (255MB)
> [    0.001885] Fake node size 15MB too small, increasing to 32MB
> [    0.001886] Faking node 8 at [mem 0x0000000080000000-0x0000000081fffff=
f] (32MB)
> [    0.001886] Faking node 9 at [mem 0x0000000082000000-0x0000000083fffff=
f] (32MB)
> [    0.001887] Faking node 10 at [mem 0x0000000084000000-0x0000000087fdcf=
ff] (63MB)
> [    0.001924] NODE_DATA(0) allocated [mem 0x0fffd6c0-0x10000fff]
> [    0.019852] NODE_DATA(1) allocated [mem 0x1fffd6c0-0x20000fff]
> [    0.022458] NODE_DATA(2) allocated [mem 0x2dffc6c0-0x2dffffff]
> [    0.023293] NODE_DATA(3) allocated [mem 0x3fffd6c0-0x40000fff]
> [    0.028522] NODE_DATA(4) allocated [mem 0x4fffd6c0-0x50000fff]
> [    0.032397] NODE_DATA(5) allocated [mem 0x5fffd6c0-0x60000fff]
> [    0.036552] NODE_DATA(6) allocated [mem 0x6fffd6c0-0x70000fff]
> [    0.038746] NODE_DATA(7) allocated [mem 0x7fffc6c0-0x7fffffff]
> [    0.040286] NODE_DATA(8) allocated [mem 0x81ffc6c0-0x81ffffff]
> [    0.041517] NODE_DATA(9) allocated [mem 0x83ffc6c0-0x83ffffff]
> [    0.043678] NODE_DATA(10) allocated [mem 0x87fd86c0-0x87fdbfff]
>
> 2) TO-BE (after fix)
> [    0.001858] NUMA: Node 0 [mem 0x00001000-0x0009ffff] + [mem 0x00100000=
-0x7fffffff] ]
> [    0.001860] Fake node size 255MB too small, increasing to 256MB
> [    0.001861] Faking node 0 at [mem 0x0000000000001000-0x0000000010000ff=
f] (256MB)
> [    0.001861] Faking node 1 at [mem 0x0000000010001000-0x0000000020000ff=
f] (256MB)
> [    0.001862] Faking node 2 at [mem 0x0000000020001000-0x0000000030000ff=
f] (256MB)
> [    0.001862] Faking node 3 at [mem 0x0000000030001000-0x0000000040000ff=
f] (256MB)
> [    0.001863] Faking node 4 at [mem 0x0000000040001000-0x0000000050000ff=
f] (256MB)
> [    0.001863] Faking node 5 at [mem 0x0000000050001000-0x0000000060000ff=
f] (256MB)
> [    0.001863] Faking node 6 at [mem 0x0000000060001000-0x0000000070000ff=
f] (256MB)
> [    0.001864] Faking node 7 at [mem 0x0000000070001000-0x000000007ffffff=
f] (255MB)
> [    0.001864] Fake node size 15MB too small, increasing to 32MB
> [    0.001864] Faking node 8 at [mem 0x0000000080000000-0x0000000081fffff=
f] (32MB)
> [    0.001865] Faking node 9 at [mem 0x0000000082000000-0x0000000083fffff=
f] (32MB)
> [    0.001865] Faking node 10 at [mem 0x0000000084000000-0x0000000087fdcf=
ff] (63MB)
> [    0.001866] numa_emulation: phys: 1 only got 3 of 8 nodes, failing
> [    0.001867] NODE_DATA(0) allocated [mem 0x7fffc6c0-0x7fffffff]
> [    0.001940] NODE_DATA(1) allocated [mem 0x87fd96c0-0x87fdcfff]
>
> And also there is other scenario tested by Donghyeon. [1]
>
> [1] https://lore.kernel.org/all/CAFPTC5e1OLpHa3HqwhtSPjS_PTQz+iG=3DovM2cZ=
=3DVnOZ_5z7oxg@mail.gmail.com/
>
> ---
>  mm/numa_emulation.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> index 703c8fa05048..bc2f163e7c45 100644
> --- a/mm/numa_emulation.c
> +++ b/mm/numa_emulation.c
> @@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 h=
ole, int nr_nodes)
>   * Sets up fake nodes of `size' interleaved over physical nodes ranging =
from
>   * `addr' to `max_addr'.
>   *
> - * Returns zero on success or negative on error.
> + * Returns absolute node ID on success or negative on error.
>   */
>  static int __init split_nodes_size_interleave_uniform(struct numa_meminf=
o *ei,
>                                               struct numa_meminfo *pi,
> @@ -398,7 +398,7 @@ void __init numa_emulation(struct numa_meminfo *numa_=
meminfo, int numa_dist_cnt)
>          */
>         if (strchr(emu_cmdline, 'U')) {
>                 unsigned long n;
> -               int nid =3D 0;
> +               int nid =3D 0, nr_created;
>
>                 n =3D simple_strtoul(emu_cmdline, &emu_cmdline, 0);
>                 ret =3D -1;
> @@ -416,9 +416,11 @@ void __init numa_emulation(struct numa_meminfo *numa=
_meminfo, int numa_dist_cnt)
>                                         n, &pi.blk[0], nid);
>                         if (ret < 0)
>                                 break;
> -                       if (ret < n) {
> +
> +                       nr_created =3D ret - nid;
> +                       if (nr_created < n) {

sashiko [1] found a false failure point with memoryless nodes, I'll
fix it and send v2 patch soon.

[1] https://sashiko.dev/#/patchset/20260417114127.1664283-1-ekffu200098%40g=
mail.com

>                                 pr_info("%s: phys: %d only got %d of %ld =
nodes, failing\n",
> -                                               __func__, i, ret, n);
> +                                               __func__, i, nr_created, =
n);
>                                 ret =3D -1;
>                                 break;
>                         }
> --
> 2.43.0
>

Best Regards,
Sang-Heon Jeon

