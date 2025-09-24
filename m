Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE25FCAC5B3
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E2B8E000B; Wed, 24 Sep 2025 07:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545788E0001; Wed, 24 Sep 2025 07:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C208E000B; Wed, 24 Sep 2025 07:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30DE58E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:32:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAB86C04F8
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:32:56 +0000 (UTC)
X-FDA: 83923931952.10.A107B9E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 827C0180008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:32:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ear3zImt;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758713574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehdJCefWHjHZQ2xeUY6vBszLodzgm+iwxilga3dW7Oo=;
	b=nyVyazvMge5H4yj1HehE6mQHQOF9y7F/OaGLC76KrhmqxS4GiR4tlGfYl3vKZmq307Z1dB
	mK5gxxqbvxveBD1C6DXuqXAwjz7YkNxDEg5hX5zF9v1MOqhvX141RRtCEcBdtyfHlK/KTf
	ydy1SfnDQnWsyu/RYKlNetn8/Q2gp2g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ear3zImt;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758713574; a=rsa-sha256;
	cv=none;
	b=RybRRFCmBr4VclVi8QtdJzKQ7aVYoty6TDLoX89Mr4PztvGeIli7882m/bIsGAB9CT+CJA
	LJXy7NpzZhHv+TPa6xiaTCDEx4uOjxVRwUGHpe6lzcSMfifISUWiB41Wv+RdTgISDQ6rOg
	bZO/guxBDeJV39CQLffMMFIeaOrn5Wc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758713573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ehdJCefWHjHZQ2xeUY6vBszLodzgm+iwxilga3dW7Oo=;
	b=Ear3zImtT361ViCdTLY+pC9D0mFFbZmEHEkVvHUQm5pEftFmOVi8xzJNy4TVRJxK0SuC3B
	8coFMJsnSJ9DnkTVOhaPZNhAA8yK7KMJvBT2/8AXai70g1nVjrTiar/t6RAwBhdn/PISpF
	03cMa76Tt9uuUNf0YJwIaLJDi8GwqNg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-XevSid9gPKaAPIdBpT1U_w-1; Wed, 24 Sep 2025 07:32:52 -0400
X-MC-Unique: XevSid9gPKaAPIdBpT1U_w-1
X-Mimecast-MFC-AGG-ID: XevSid9gPKaAPIdBpT1U_w_1758713571
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e19ee1094so25819875e9.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758713571; x=1759318371;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ehdJCefWHjHZQ2xeUY6vBszLodzgm+iwxilga3dW7Oo=;
        b=cCLcTWCdZC62/+Nh3iOpEodUWJ1luMACmf2a3K/ntX4Xv3r0Wkcir3/S8li58yK5p2
         pKRkziKIGAOVUmb/MGXdb8T9UPMAA8iQly+VH3A2ESuzU6ru8ZIfh5tjLd6R4YL1Is7Y
         V23Z8jjRUk7WvU+xCaF/YL9p4KitNsSqFRP66K4Ucw2XejptQ96Hu5S6dpSQfGSYJLeB
         cTAZq8rHz/AndwAACuCUPJEhNaD7o/GJL9RYagMuvxSqK7ULQwTj3zA+aaUfT2a5GeaI
         3ka1RWbRHAFGhaLLsMRBSUAU3FoUW+5tA7d5/Zpn6ssDSwJXil83rjXVolUtDv0Fhvfc
         9C1g==
X-Forwarded-Encrypted: i=1; AJvYcCW3Ziga+YVLxhtylyHqSllSa9Y8rUd7HYT+fO1K7wSAg0c08SKO1XqwW6ZVh9EviRBSwN85Re+lqQ==@kvack.org
X-Gm-Message-State: AOJu0Yys63BfKTsmHGvNP35LXmKvJKm3GJ6fXnE+NIc3LyEgsTmTnesV
	xHp4NZDjk3zvKlrBrJdMvECujTgKZS/1HIAyfwGyCeSWeqn6nWs6b2jzHhYRYRrnhsd9qPrymPN
	ONdovvzr9QaTYlHG1ijbuNU2SJTgHqOe6zlwDQiBzHFykH3cI4TRj
X-Gm-Gg: ASbGncup+srNGYFl+o0r4FVu7HSHZIUkLMhp36CXnDo2rD4YZu1zrWnof11pnCfj2Fa
	oxobH4XJXfF46eOqO0gxb0rkg+qUnNWLIIdGkcE80OiMtDBm5c6Hw//poNT3MCmMuWJnpoyaYkU
	Y0jUh+PtLJ5nNekidH65KhhtVt/0DPzXK3xWMYkUpN4/svFjSvZmqrU4mvpT60GFTmIA87UBj8J
	MTSM5U4dgx770ykW/lvvGYMLbtfFrQ74OJQ3mfuoEmiQXGTBVqbj5SstOyaRtLgjAuqAwdqbcxp
	gKg6dgwJ/wVilysk50O/hKCH8bJ2yNvHk73ubjZVGZfqmLdBxnF226et8vRwaIAKiI8kHN+B7rx
	q1PXoiCNXFPL+dGsxvwaK8NXJ93PHvOzMnDv2nREn9RS9En8Orx2tqBoODdjZ/pJlhA==
X-Received: by 2002:a05:600c:4ed1:b0:45d:d88b:cc6 with SMTP id 5b1f17b1804b1-46e1dac188fmr61037675e9.25.1758713571147;
        Wed, 24 Sep 2025 04:32:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7pGCZ1fOiVqtAVOm2u7cESZGBYcjIfXBGgaEl6BtT//qVBAhf53t3ShXmK+XZpgtplZVSlA==
X-Received: by 2002:a05:600c:4ed1:b0:45d:d88b:cc6 with SMTP id 5b1f17b1804b1-46e1dac188fmr61037115e9.25.1758713570613;
        Wed, 24 Sep 2025 04:32:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996d7dsm29743925e9.4.2025.09.24.04.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 04:32:50 -0700 (PDT)
Message-ID: <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
Date: Wed, 24 Sep 2025 13:32:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, linmiaohe@huawei.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nao.horiguchi@gmail.com,
 syzkaller-bugs@googlegroups.com, Zi Yan <ziy@nvidia.com>
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: iET95bDZIqiOfL2NF29ZIyHHG6fNrh6aG6NCT0GHgX4_1758713571
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 827C0180008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: erfxapieb9b5imfmmjzyis989pu9jb1i
X-HE-Tag: 1758713574-86852
X-HE-Meta: U2FsdGVkX18P8vWpkyned1njktsj57tmJEG9Wds5MXbA1UNyI2COuPUXqpWe72TGuwLiMNgIku5BWHnlRt2EH+RCZyB+HA69aURUjCLHwkOaFesCN8He/VS6qlCfbrwu2YvcEM9GtA46u5LMJb0xW+/Izj/bEOEtUqIlz3VTKK8cqq7NH5xr50dkFG0tp2Pq8M0IW6vaOYzv0nYEeLHxLE4kEzIEqbVy72zNjxZR8UrRDYOZ1RbtpejNfVJ4T4VlrYArjx/8dP5sNw9Y5Y19KVuRv54brD4dqEK9sMq772kjAO+zU/q1RvJQXZZVFmuKuCb14K1RAHTZNl//NM0lBfsQWiXv9N5xV/d9WMLB9WnzfHzqASHLBqraF5dPmFMR3CHyS7W7iYP4MQP6yNsogX11dYbH0SmsVNMCKMXAxnbNKSGAe+0s0i75ooY/l5uQ8QMX3t8dhMhFNVRnD6e6umxGtNdO+Ki+/8CRNTiP2759TtbVRUgRs+11DAEUR4z5mb6sXJnMzlj+ovlMqs/dFoSDryPcd3Gj4sCMXqMvwkM/Cc8WONzjsslqpfc8wRA1IeDLU7kE3x+lmxJeMCGRCBlA6rnzoP+Ak8+f7EBOt9llgsYR4A3iGILblOEf81n1eyFpHBiATtTg4TlQ8t5TLWISHvYA+CHhLdqdK8U4XTvXOV5+QFooygPCDkiXjkJFdSrrghE+qhBTX2KozSTEdxNrVwnHH9fNuruplySwrWGTRyJ1v7Bry4j13CX4IOb7/fo7TnTQAeFPe/q+c/E9cxBoVqmkvxtNi8F9epg9O+u8D0yjfofTqD4IVUK6iieUlhfX+6xQUr9NJ2OhODBR/wv/HSQlCWbfum9/2ShbsR1c6HVLbKHgEyCUhSLprSDEaeDze5BBFMRgQNP1uUxVTUiJJQuRDojo0+IijxbgJ9JBwI0hey5HHn2T5zX8JL+iOKK9kTlnlo3Bfe54Bca
 RIP5j+Xb
 obVLscz+ya1sTzv1uWjcI9IYXSCfRZtDTdYyK3teZE2fgKli1PVG7qsdfATkQBIlOIhDBSXZIbN+xWlvIrW8ZbwUUyl8mB66qXw5WHbfV2HlYbysgxVWWsfBUuh2VdlBKsNo3MX0BtqiMxvNigEyVm1Hi6jfES6q7iFfpRk6/YwWfqgI9NETDjMBASOmBkMqqimt+0FtoylMH1g76zbkm+62+vCzbsDlFahUB+YrYv13V5ucQ0sf6GezfTUmf7rsueIEQMOVxVwkbhN2wrnE6UZwqPyhHbljh2uOkbShQTDFxNn+p512N7HF+NL+UhCx0kZera9YEus8qWVLuZJMuclv+Xzu4GPnAkEwlrNYFHuGzen7omIhSoxbwp1MM6OKoIp9YXQy+B1GzdVj+zJQj7pULBgMYNhVnvhLx2UgbjwcAcwgSaqXZFjdWmyf3PgEe5Hy0y9jQqlM3OPbAxXu92fHLc1yfYIFUbRTUDy2KJ04kHsDS+Xoomtl9+Ud+S8urHYvSltrWIRn6iAB8FbMux0MzlPB9tM1GMZZVDU8krkNs2m3Rl/4fbF99VjhrHsvjgptiu62OVwbg0YCLXKpG6bmD8Uc1opXWtg38XURaGabj2wutI7wuIZ8I+ES49rVuUcXQMTVyCgIwUM6EYVaPxj6qY7Y9WnQxslxLtWswzsXojTwwyEIrt6eU1moHuExFxyTR8Z5p2i3yox011C30KbNIHF9mR94J8tcjBLT1aL89zQ2etU52srr0no/WcFZOrI4sjOQ/Vs6deiuGL4ohROOrITbWbbULQEMRWKV8YLbGhJyBw3zz+SdKTLfoH2Zbx4B8ObLlFHUm9flUtTqs8l1ZqemoLq3Uiu2N0ZrqIIBsmSMagrg9ay5NFOP0MoG2VClr6IYLD4zLMT9I0LCA++HbdfauvWilIJtEnC/K39wxhLesHbLqn2oyx9UUGdkYc28QajYeT9MbPCYEdPVwajoc9z9l
 oSJbO2t5
 tt3u1vQjaT/ajM7Kry7kMr+wzfsDZOKNzS/FO/qILXhpCy3SFYCket3+YZBPilEDGcV4cm9/mrWiKw23pnkKQIfvldIHcV9QscIZI8Z2rrP+tvBR7O3gSQfhpT2BE3hD4FM24eFzA1S4M/G8wZdPEA8mJ+hG/BqtiEJxeZw8IpY5sWFog8/Een9dHLtlLTxmIzRZ6OM60KrYVq4aDrAdCPrEeq+W1Pd8CpXslsfW2OdDHsIBf9RAv1ulwy7rUCHWBqhku5qatZqiDqmfwzZCtrm8Ix9s5px2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 18:22, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b5db4add5e77 Merge branch 'for-next/core' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=10edb8e2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d2ae34a0711ff2f1
> dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14160f12580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1361627c580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6eee2232d5c1/disk-b5db4add.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a8b00f2f1234/vmlinux-b5db4add.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/fc0d466f156c/Image-b5db4add.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
> 
> Injecting memory failure for pfn 0x104000 at process virtual address 0x20000000
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 6700 at mm/memory-failure.c:2391 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
> Modules linked in:
> CPU: 1 UID: 0 PID: 6700 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
> pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
> pc : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
> lr : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
> sp : ffff8000a41478c0
> x29: ffff8000a41479a0 x28: 05ffc00000200868 x27: ffff700014828f20
> x26: 1fffffbff8620001 x25: 05ffc0000020086d x24: 1fffffbff8620000
> x23: fffffdffc3100008 x22: fffffdffc3100000 x21: fffffdffc3100000
> x20: 0000000000000023 x19: dfff800000000000 x18: 1fffe00033793888
> x17: ffff80008f7ee000 x16: ffff80008052aa64 x15: 0000000000000001
> x14: 1fffffbff8620000 x13: 0000000000000000 x12: 0000000000000000
> x11: ffff7fbff8620001 x10: 0000000000ff0100 x9 : 0000000000000000
> x8 : ffff0000d7eedb80 x7 : ffff800080428910 x6 : 0000000000000000
> x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff800080cf5438
> x2 : 0000000000000001 x1 : 0000000000000040 x0 : 0000000000000000
> Call trace:
>   memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391 (P)
>   madvise_inject_error mm/madvise.c:1475 [inline]
>   madvise_do_behavior+0x2c8/0x7c4 mm/madvise.c:1875
>   do_madvise+0x190/0x248 mm/madvise.c:1978
>   __do_sys_madvise mm/madvise.c:1987 [inline]
>   __se_sys_madvise mm/madvise.c:1985 [inline]
>   __arm64_sys_madvise+0xa4/0xc0 mm/madvise.c:1985
>   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>   invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
>   el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>   do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>   el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
>   el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
>   el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

We're running into the

         WARN_ON(folio_test_large(folio));

in memory_failure().

Which is weird because we have the

         if (folio_test_large(folio)) {
                 /*
                  * The flag must be set after the refcount is bumped
                  * otherwise it may race with THP split.
                  * And the flag can't be set in get_hwpoison_page() since
                  * it is called by soft offline too and it is just called
                  * for !MF_COUNT_INCREASED.  So here seems to be the best
                  * place.
                  *
                  * Don't need care about the above error handling paths for
                  * get_hwpoison_page() since they handle either free page
                  * or unhandlable page.  The refcount is bumped iff the
                  * page is a valid handlable page.
                  */
                 folio_set_has_hwpoisoned(folio);
                 if (try_to_split_thp_page(p, false) < 0) {
                         res = -EHWPOISON;
                         kill_procs_now(p, pfn, flags, folio);
                         put_page(p);
                         action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
                         goto unlock_mutex;
                 }
                 VM_BUG_ON_PAGE(!page_count(p), p);
                 folio = page_folio(p);
         }

before it.

But likely that's what I raised to Zi Yan recently: if try_to_split_thp_page()->split_huge_page()
silently decided to split to something that is not a small folio (the min_order_for_split() bit),
this changed the semantics of the function.

Likely split_huge_page() should have failed if the min_order makes us not split to order-0,
or there would have to be some "parameter" that tells split_huge_page() what expectation (order) the
callers has.

We can check folio_test_large() after the split, but really, we should just not be splitting at
all if it doesn't serve our purpose.

-- 
Cheers

David / dhildenb


