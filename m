Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3FE606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 01:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Xtj1CBUS
Received: by kanga.kvack.org (Postfix)
	id 0F61B6B05B0; Mon, 26 Oct 2026 21:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7026B05B1; Mon, 26 Oct 2026 21:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE006B05B2; Mon, 26 Oct 2026 21:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1EDC6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:06:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2378E140303
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:06:52 +0000 (UTC)
X-FDA: 85366616664.22.8F72FBB
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3804BA0008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:06:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xtj1CBUS;
	spf=pass (imf25.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793063210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJI0hb4/E//vLxc2EVc1E27ZXseuwybs0SN1EQUknec=;
	b=M3G7FJ8QOyXxirYgdNWCrQQCU3920M1s3eELEQc91L15sSu3pT5sONadvH9h8yzvLXNJwN
	rWXU1/PrZk8A0VBSTP0ld29oINUs1qE54xTwJ3uqiDOw1KDxnHgJgCnYBT4Pp9FO8HSpx3
	er2LJscCjlwzOVR4R+4CD5BDlTnkdHo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xtj1CBUS;
	spf=pass (imf25.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793063210;
	b=3OcqDWV/YhrEMT/UoHjlopRiM7PLR4JnZDVl+ZQg5mmDGL4y1nZJ6mvvxUQJ/O46jwcxnk
	MyJlOPp7NqL5B6y4yCnl4iVxQKLQu78q1QDu8CpMzF9IRMlcgp4LetgjcxeKRI3YY05XKJ
	9aQM4e9zygRifD53Era+hH/e7xods8k=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c315869241fso467858566b.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793063209; x=1793668009; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aJI0hb4/E//vLxc2EVc1E27ZXseuwybs0SN1EQUknec=;
        b=Xtj1CBUScA8jFCX+R3PFx4FhtfQuZkqAjiw+SBp1eQxwXpIiHZiQYaGMnhLw0RWt4I
         AKovfnbsW2Ii3cA7wC0qN30TlQXYO+KfL5D5d8msqnP3drnhwIdYZLwm7knZblxwp5hL
         ZmQ9+4YdWtA4/i2K0+1BPVA6ntAIftI4Lk7N4iE3sjAm3aMed0gsIUZ941GQB850F+se
         6qkr6LgrTG1NL8AKEWkVzCoVHptuPxRaAzoy/GQdp7q2VLkXAVsCbnZ/OGrGjbFZmdT5
         PzGZMhLLBE9TikEN9WgsYcl/5eAtJtev4j0HFImUhFKwVifP4QdJUmmjECxVWMwm/nXV
         eLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793063209; x=1793668009;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aJI0hb4/E//vLxc2EVc1E27ZXseuwybs0SN1EQUknec=;
        b=lnpeNSLe2TrQdLRGQbYderK/00rEeCch+Hl7wGwFHgWMOO8dm4Zww5CnInSsI9ghPp
         pUs8hFRTHu0mRwHY8XxIjjU5oD3OLLRhzJ1gM/18RKRCRb37ZapwkdrBVc9LGZnnU65F
         HV/IPkSuHFbEgOUr2dNf/vwkcBb5euWRL1lcv0yK5ORaMEohCpebOxpQXHiXYLJYXDqb
         s4D676TE6Jxqg7yZhvS5GyFvcTKfcsmoDN09NWQzPjUj8yQQOEniQqbLwz4dymBv/8uj
         GDRmWjXjgEd1FOKl2N9TFITBf6mBIGaAUGJiN9PPl7pvOrBfsOHAEn1jFraJLEIEtaXq
         MSig==
X-Forwarded-Encrypted: i=1; AKwUvBxxM6Zs/klRUit0j12SZxNpCzozpqRTukU4FyK71iNF3Nfr7PT8sVm+NMSML02sCa/W+5vKZVEP8g==@kvack.org
X-Gm-Message-State: AFq9FYKnMJtwSs/vPgkcohaFAEG1uxj62q3JV3yY6BT3Oabdn2ac2Ftr
	K+udZGujecRgLPjEbV6YB8O+CrEV1P2cFh3mI0tmYMMR7jookbQBa4Lc
X-Gm-Gg: AYBFou3VvCVeQ6+KJhfaFuuuwA+IqdGUkD1f0NKvh13U9MwB2M220vTqvVkUy1VPTIl
	ELKCu9djGNbbNWemZrrtrLQY0zmEsI/sqhItjIOHhlP/pbh+8h/WfyFfd1ASMCqfM1OHBPgmQVE
	KJZjSO6J9SKzgdKbRJARjyxrvYCCQWYzkgzPE/PK92KY6sSF5q2QfT8JHKXOpSvoQTRyf/Qze0S
	5UryCbORDvwQTOqYR83zPbqREUzxh5Fu62r0q5jEzH1NUzcKCZEIy8sSYvusLK4xKEIkUXjYU/n
	VeqlHnt+zPjz/8kzUUK9aohza46hwF3EDnJlOGDtLzZbsYGACUSRKcFVEeL3twNbsCTWhvqkeEE
	Bgsfuza2UTyZ/OozGmiHHNZgdyUJRJKbCK0CF5EfRc7ydSgp/AHuWoCtQXdG8cBHj/AAPSSVHI9
	c4OJXOUkwn37X/sHB/jjETzbeYZeO199CjALQN+sXh635qnNmWHwS143M2pFAQZgyK5eXGYrx/s
	PecmLJzpwPCIWg2falywnxjwHcYCVmqCqifArPWtYAZCL3gAVxWdXqs/v7qrs84fz0ppLbZjLNL
	H2ktoL02rD69lL/iWDhx+p23d3Ic8ZpYbfXRJkKAPYl//93Y1OkDYD4I2NmOgo1K0/V5CdUYZeO
	osugTAQNWRsIjqJnG/61+8pSvdPSxjA0bizNJIMS1FBiMMNntObHdoaQOb9xx9IqE0VYquOMx8M
	ADE4rMDROtMBvQb0w=
X-Received: by 2002:a17:907:160b:b0:c46:6a50:40b7 with SMTP id a640c23a62f3a-c46bdd690d3mr894395066b.10.1793063208643;
        Mon, 26 Oct 2026 18:06:48 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd4e7c94sm373434066b.27.2026.10.26.18.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 18:06:48 -0700 (PDT)
Message-ID: <7c8d96bf-368d-4272-8cd1-94740a2e4a84@gmail.com>
Date: Tue, 27 Oct 2026 02:06:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] kernfs, autofs: fix pipe lock cycles through sysfs
 stores
To: Ian Kent <raven@themaw.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 driver-core@lists.linux.dev, autofs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
 <cover.1792577179.git.krystianmkaniewski@gmail.com>
 <dc65c28e408d6b64d4b13b7ad30e5fe70ddaa441.camel@themaw.net>
 <4f56c93a9fc5fee152364974773df0a319c84af9.camel@themaw.net>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <4f56c93a9fc5fee152364974773df0a319c84af9.camel@themaw.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3804BA0008
X-Stat-Signature: 5ofuo87qc938m4qu8txkz6c1j48t5er4
X-Rspam-User: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793063210-266900
X-HE-Meta: U2FsdGVkX19Fjq+KtVDa+NxqRnSMGGAUenK5Z/6hFYIqfFbILVKV0epOO4/78UL9razGQdiWJMv8vUcHq3QQVjuEpy589USDV9TFox5tktZykESSCpD/qT4y0r6iyZKv/ZyvruriL4Gjgzmjr/olGjM7rhaXQGT5t/sTF+xq21h1fTkSis0dUfln3Q4z8xdayH3ACo5XXdsAwKohaW5vhqk94+46/VIIY10+kn4qEuq+RZTj3Yf/lV7Has9LihDgVbKvoiuvy9VJamjGUAPbZS1sqMx9pUJ/+KyRz5/Xt+d0QTClhyA4g0lgzI7tV1LP3m6+dQWf3fqANYFgs5Yq+SXfU8sgPMNu/s6/38lfKN1cElxbPkVsHTvxLYRspPNlXljP5uWvyCaH/S9ZQuQvWUjhUFa488GwupRIFcA187chPl+/5SNeQ8odx+Rqv3FA/RJhcNFw7JjDtHEzdmAF5gBv/udKvIQDf5jrF/RfGPB6b+bq30EnrDWQDJjOCloZot8JZDFPsob9cyq0zXUUo6awI0r1bm2Y2YMg/sLOJAiGSoh3N8PJVOo/i6q6yR0/1U1ryIbKTwpxB7rwQCsPhrxEuQ77F+vbhbeI0yi1DbByuj1BUnUyJbCKm76Llb2nD8K7wYeAg64qUYhmv8lN439R95nf5qwwUBaIKS+lKAP4Oihi3tA5xOq+J/MnDBXgZeWMVGkgWrG7+PbJHfiyPx29gkRyg7HLNAWxGi+8xF5y7Q0kD0FqBFUbb2tMv22AsGcu7sRO9p8iR+4lTF+yndWp6UGxwxa1fi+nnQeRY+1EPUUoGTNXlZ6naVsUTA4LSfFsInE9+G9viZcnS1AVFrqxs4hWHsVSXx3B22wRf0SzdAragj+9Q87Tx08uDNb7mtAiuiKz3zzJCiJu/m3OgM365hI0nrSgABh6ytpCs0pTCGBFXAkKXg1Gv/KuihIHNoQIUbUwdPbzplMwTGv
 KX1IXC4P
 Q/AMZU7Ci+ob7hvm9oOBIghcJc6lZzl5C7F4eaYzmjdhUVDUuh2nKlz5FwZVKlC1mJO0n5edl9Ub0y2x1dss7aDxu5VMudqPZ+99HpSAqq8+ViMwzsW6W9Bh6alID21G8mRKuPw7usLfF3mM/vQ2c8uJkKpehjUht3blMZuUg9bNIX1gJR5HpQwyLxbO94efjnNaykd2V6x6wKIUCbrfKrgBSGH+K2PF5atEnZ31XT4mdJDwccecw0DkL48icgSaqesDTrBHBtWbDI8xsuT+42AgDKOJwUWnYvEm761uuHV2M4qMablmm6g/5ZOVCsDoeGtFotcrvNleIOszhmAdpt0UVxBTFAJTvjQjjp1+CD88beNN+vDPEWPaP0zTUSR+VedxOcB4q7PYCd4vFcTv1Ewiiw6yzgUKl7CxDEbRRSrhkPnV8ooEuGmBBC71BB27llMZWKOtTG6TgaIhmbrw44hhbihgHrWGcO9PLNgY61xTrRoCGhbFksD/mGVPxetXDMBq4K5zWdTpI5Y4KnozSD6bAKV2Ix+gzIOX4+CKfoBCX8ceSkKH6OsEfgr0SkjxKjYOr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

One additional detail I missed in my previous reply. I reproduced the
warning on the unmodified kernel at commit:

        93f51579e7df248780214094418f205253383cc5

Exact kernel version:

        7.3.0-rc4-g93f51579e7df #1

I ran it under QEMU TCG using the configuration supplied by syzbot.
Both the unmodified C reproducer and the original syz reproducer
reported the same lockdep cycle.

Thanks,
Krystian

