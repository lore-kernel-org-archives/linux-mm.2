Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF7D606A330
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=aX+bu5ir
Received: by kanga.kvack.org (Postfix)
	id D4F856B076F; Wed, 21 Oct 2026 15:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26D16B0770; Wed, 21 Oct 2026 15:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C167B6B0771; Wed, 21 Oct 2026 15:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93DF16B076F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:14:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0776F1C35C1
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:14:49 +0000 (UTC)
X-FDA: 85347585498.10.B39A313
Received: from sonic312-27.consmr.mail.bf2.yahoo.com (sonic312-27.consmr.mail.bf2.yahoo.com [74.6.128.89])
	by imf14.hostedemail.com (Postfix) with ESMTP id EAC43100005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:14:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=yahoo.com header.s=s2048 header.b=aX+bu5ir;
	spf=pass (imf14.hostedemail.com: domain of casey@schaufler-ca.com designates 74.6.128.89 as permitted sender) smtp.mailfrom=casey@schaufler-ca.com;
	dmarc=pass (policy=none) header.from=schaufler-ca.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792610087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvX/Q+HSZkDnareYTYW1vtbpFi0/voK9jxtB2w+Yfp8=;
	b=gLUVIgHaEGROzZE2BFSViE7SaMG564PiugEly7uJb8nRuxiHlFa7A5cog4+piKNlkR3siD
	dHcGWTlOp7v+B/QHzLzjK9YSuOVbohNr0CvYe0EABPIUemht/qybfDcmZ5ur3SdyPJS4vl
	Ha8FydUUrpVStso632rpKjk9/QwYnMo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792610087;
	b=S7Xaw3//cNpdr3heWSrQuih75qZrCUT23bY1NI4VvhJ6ZkkHZHGafwfFU32oQoimbaWEvt
	51pclZYH22Z8y6rPaldG+fDn8lMmv5sV/Qv2Pjc+SPAO3DXHQjip6d4cdiNoOGZwIDpqQ0
	3DGYUZtFrz2snKnZaWWzXmxLaXlwADE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=yahoo.com header.s=s2048 header.b=aX+bu5ir;
	spf=pass (imf14.hostedemail.com: domain of casey@schaufler-ca.com designates 74.6.128.89 as permitted sender) smtp.mailfrom=casey@schaufler-ca.com;
	dmarc=pass (policy=none) header.from=schaufler-ca.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1792610086; bh=fvX/Q+HSZkDnareYTYW1vtbpFi0/voK9jxtB2w+Yfp8=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=aX+bu5irS/pYE+5Nvx6/PSo0lpu72GtYglM1TRBramfQQo6wuPRybjHMsGswpRJ17Fu8u3Y4o0C8ZdNRLyD/RZFaGrYlZlFB4KW+ee+kGHXWVQXtwSyb81afNLsaSkch8R9ZnGrovHZAZb49lAMr/TpT17KKJAPhOQ8BO9JH3eKgf5gv/xc4qD2LOoHfmrSbnA9HQKV4CXoRyQpiF7EAa2bHVQsKlug9YYPpjJKkUoo/74ZtvKp9EfPeMQmr703f8d26PBTsOvkwtMY5Q4jXRuw87c+Aq/+C0c/TkW+J5ukLka0XbOZvYLsvdf6p1oNRP3PbfmnmSzKINDrqCC2jqw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1792610086; bh=AC7mZVvXXkC0jGc51fQGLYYjfwjktj3zG0RIDl4ygn3=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=aotSkLCsWXaBoLqV8Q9TYPm+rOT2xj5peTyhwGWHnRv3NUkzueMMfoPuuUU4E9j8xxZFYOak6rwCJiJDcA/+1cchO1fqdYnVIuJWrnpEFAPzID21MXzdHYSLwYFPLCLOpoRvwxRFoQmXtsAjgW1oY/s+E2kmxJHT8RSYZxgh6XuDIgpJf+kMfPIO+vIBRx7HoqWUmTr/6WGyj7BMpgLR5ic5f49z5To4xSACpvLd1E9tyrWBSaIjJ756v2XMdjinnzAUBZx3+L5xPaGY/5sOhPGjkPIc+ohPF2i8uKrUFyKR6pGnv/4y9rSjbZYfPXfyBVIiW8etpnScbbcQ0F12cA==
X-YMail-OSG: D1Lb96UVM1kJVLOv40.7KBova9aTAPdVOvhLYdXpYoso0L5aaLBQJaXu.gN_eUV
 BRfNL1vg6WDJAtVaQVVJSduJUa1kLtdd3ygVnXOa7qs9UKe3AOp6DqaDBh4t483wRhJDo19Ly03Z
 ybPYhjwaXN45UycYriccDxK9rIk.fiI2lfPp.4jv.flVTBH82EUotU5N6zB5WqRk2iyGLoZcguW1
 pGdRVC.Chfa_9hPSPu3WismlncClsscS8FPg2cWhwkKuafepMRXvt.6bU1UrHKCIgO043o8cS5.x
 EGBFpzY5uJPKMs5qRU4PXFJFvPf64L0Ae9Iylo4XDkXplftAvUle2O8o03L3HYqm83ffKOsDR6kX
 DW.Ee4Yzw3QSnELi5tSaK2W5JZ_qwOQZ3RdXhn0uHOHxDDC0aM3Qd53z3eUaPLLn0Jb9avybnQr_
 Bb6Qz_PkGOwIoszvFjO6bOuewi9qDB9fmr9vYyL8u76P.Z1bLglVZ5T2hWWJyuSjEFDeQc8exVJg
 9Ym8rZSJnmUD8GUFvJ1bM8uBUId7m0hFrW0Fzp0IMr8p228GY4_r4o9H1dUngvLoL8uJwrEcUE7s
 JC2O0aR5XFzXQHdymYHmiJF50TgXyS59LO_pJeAxHJdsQ4_6Qe0DHx.uL7xSetf1YUeQ_E63WoPs
 oxusDqKspvX.70bIdUIDp5i7CvUB3YewQX6x0wDCQDYPNC7HkgMIDFZsj.yFctoN4g3tKR5PIzDI
 IR93YfR624itBALsaNEJ3jB.fpDfTRjQlPaFQKSr2eXhDRbI3pkxGST7z053sA22qcVoIoRcpIEf
 r9GcVZQ5ktSi6dDrEHFSJUw_88ky.uHGS04M.TMx3MVBTdDtJIitqdrAETfFd9QxhyKQYY8_HGpq
 0PMKyP5suKQU3drj2Se2NHMf.PhBc.jTS_9XytTtEJhI9A01Zu9CXAbZznF6QpDPRmRaK3CiGQ21
 1Ab9huYxWH8BsMObGIl1oZixf1cUrGrU8e4cHH1zhszIhCRBr7BTx.uaFgBP3lGDvtU2cMMiASlH
 RhIdM_i11JVL8YYLGQcoPkdkw0LvO5fyG08eMLtBSBSKI115WFnW22G099o7xMNyqrVl6jHC9uiC
 hCrUJ4p_eak_MtbRC0jcWU0M37qTH4FyZpDerFJYzPe3EeM8Q_XNQt8taVaReMvuPOJUEWlN6qqc
 3Aos6.qOc0rjPwJYRs0dsJLIxGEoUmM5UQG.dShL1LPPsXnpJW_PPHNtFvRcyTLoOgdHz5NxeLuM
 k5fcBKoARDt87iHzsue4hFJiEUvbwUfHhhdV6oNoZDUIpzlEu1YIOhrTzv0oLwn3Tk49_.8kgyzf
 Ja1nVgnNL76C2aHxJDNhElGn8lhia20qerHj3fi.xZNaHAACmRizWnlhvdIQglriE.B8G_TeA1_H
 eOjfoZJZ_B4OYSAXhP.zBXsHEzcTUDojootgOdFapHHM0.ABMHKaqe2Paa4gLnPMnbgjsHfKetIO
 xdtICoYlIaczlPn6QXeYzw.SBKY4TTrT3mIQfUNBFmP0usCBVFIP.SMoczWtEnpCIOaIl9LR170m
 O6zxJTv_vcq9hFMFgb3JJ84Hel6ObctGrBB_sBu7RMg_hKblnxE2ziRsy7zOwDO9fcpCPCQcJIaX
 4umW0gD0cZgEzZYGOJ9jeZ3Xtu9BaCi5Wwuc7TKz2LHXB.5zJGCIXA3zhscNDR.BzN9PU0lu4sqM
 rGhE_XUxrYukeiu35XuE8Bqn68Yq_MMhYVS8oNfAFyaar5WmGX31yG.sCqVltmgqXb8FbHp_eNZC
 aorThJhHmww5pA1S_OjzRrcODMu_9MxjwX_iBVd5f50GVnfZsOvkLWmQx.oWlB_qKUnnDZiuj2yf
 oPaoz7V3p8P3rshupMI7UWL6K2Z0l5eBDTGJPXonzJUZ4XzF6Mh8g6Z_zogaN_M9fIqz.QTF.Ana
 iIO57.zNJ27U8i3cKAob_QqlwK9g4n03AlaWXFIhopEQhXxx3IbmnyLiHAlujqyQ06VQw3Rk29Tw
 C5IYHcfyg.VMQAfD.SRidnUis2qldLgct8Vun4MZzOKOJ.DrW9bWJJNuB9SeMTPigg5ml.aEk6fy
 bXHqEn3hE9PFhbKtyAA4LNhdhriuQy7XxKG7NUXvqhqXgmyUlz4_o0.HkgqGVhfcFalW4gCXL5qh
 bhI_kLiOry3BmxgpMH3.xvJ72t.HknLH_Mxvifs7P_IfE4KY3b_lI6tuZ6QN8u8_sBQKl5fGQqtb
 QvyqXo7O8Lwh.CJtmhBLMM3fk8ui26cJ0UE_j_I9Y_8dMuArHuO6saqA08AV7qla8jg--
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: b807fcff-ce9e-4a1f-a5aa-2d0d8f37673e
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.bf2.yahoo.com with HTTP; Wed, 21 Oct 2026 19:14:46 +0000
Received: by hermes--production-gq1-fd7994565-nddcd (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 4149e187089f1702b1ec33331741c541;
          Wed, 21 Oct 2026 19:14:41 +0000 (UTC)
Message-ID: <fccc9441-1909-4988-802d-5c9d7829eacc@schaufler-ca.com>
Date: Wed, 21 Oct 2026 12:14:39 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next 11/14] smack: specify SLAB_MAY_ACCOUNT for
 smack_rule cache
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Muchun Song <muchun.song@linux.dev>, Hao Ge <hao.ge@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module@vger.kernel.org,
 Casey Schaufler <casey@schaufler-ca.com>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
 <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-11-096800aa3330@kernel.org>
 <0aeea80c-e3ac-4b6f-b1c9-ef18ea2964b3@schaufler-ca.com>
 <atkEXgQNK05PGTMG@thinkstation>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <atkEXgQNK05PGTMG@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.26740 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EAC43100005
X-Stat-Signature: dxfic5eoc4eqhtjdbabinum64da8pmuk
X-Rspam-User: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792610086-800361
X-HE-Meta: U2FsdGVkX18ta0Z0Kc2WyDPINxDOJZZTvMxuRATt8ZRoIjIo4d5AgGqQ3EZK7QMyQTdsrKooa7PkqgmnOl53FuB3hEPCTN+S9wg8vt64WKozg/p+gal9Cv0ck2a5YWbnuq52DY07nXeXm7BvBdJbBPa4ty1juH2o9RSZ+34+FYEVWHkCFi8MpQaDvEFZmB1iUPS0bVr0FnpRKXhbA8Hv/xp9diNPLgl8pV7Ev8ilMF0AKw5k3bol7P4ZkFG/kLjOUfaFVDBl8JI+3MDeZIiqCaeuCKRH+bpajESxX+1QAyIyp3fomPthUlxkwzg7ZGdrTuvy43J8M4L9Mi8EFIrGCHyT1N0I9fU/sGfA/K+ANGEt9MyayEHaCyDlObS6qumZXEvP2Q/MA06SP/DUX4OOR7fmONMnd7E7UuvID9iT5XPRzSts2g2rlKoXLn2SjGGQLDNso4HZvNnK/wgy4qNpa7zPb7oOXgZ5C9zIuZRW8g/EzUSkBdAGu1TAFWNNPNhZBs6KW/Va1kq/GObhsumhM66ZW6cfS0kSs6+VX9oJWVDs5SSdFGM7IWSOKLq6ghvr8d6ZFj65qeA8Uw+ngEXI/401PkMRwio/XsrFkN014ot8U8sqKq/UtEdyKoivTAAT6LNrEXxZA6gVXswRW+f3I6sRRcmtoL5iwnxjXaZvNabrJzjdTC2N8UeC6JK5BHgASjTt7b3l6ReiPXVikbfxQdfJD+iMnWK50kluQsd/frRsB9L4JK0ZlIlDtz7tMWxT9/JJVVloizwqSS1itb3KRAUHbFFz892h1xkXpbemeQkzX+gT5UogIHvjogR5MgCsNAS5L3E8Ke9ivoOREvW3e1kcoM29R5rc/eqluzq4h2RpQZdUiR/cuFBMAMBWlZaP7aKefoQxiVoOQnP46Ky7MBIRmsnQH7FLeUYdfeLxpjBPBTT4XtflS8VEk7MBY4MmXs2LH5kW5BspKTMSAku
 NdqEZjdF
 0sQYO2oFyw+qaq5uRIjcYmhrNpvEfuf/iLsXdz9GzVxMWvi4O1034docWZ9tph4YWgGIt3ixaSUZbOEcWnLfKL4nh1J5tDaLpfZPws7kEzYHsjHZf3A9Z1HcxbUsbBBZ8ORuN5lNVuoyxy3TkPtCO/88RxcxXitzZOOU167qU/9b6a8895WfZhyD74SpM/01LW5y0cDRKA/j8yZPw4Dm6K4qT0wu3LusAo/ksg/V5nEYPHyJYBRVVu1hs6pqoKNKhN7yXHCSTrzE1t3IAjkr6XULMlLcZw+1taW/I+GPyt/uNyeN71w2aXHzmR6bSvjCRjMT/iEJGvl6vDdxgfwKsodqGDbskC/SB0nzFz42hDZeUd233QkE+iZM6k2h+Ra1J4vv8jWBqGNvgdpFVZhLa0TZLwxzAtHPVbDg90RUDu8CL/QyLc/CDEzFEjQqxa07ILHyrb88JMIPJMzECRGq/R3ls6WAOJ/XI81cf3VaOBfFe8eOyxOsK95JZcE2t77UXxuSb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/2026 11:48 AM, Harry Yoo wrote:
> On Wed, Oct 21, 2026 at 09:59:15AM -0700, Casey Schaufler wrote:
>> On 10/21/2026 4:46 AM, Harry Yoo (Meta) wrote:
>>> smk_copy_rules() allocates rules with the gfp passed from
>>> security_prepare_creds(), which is GFP_KERNEL_ACCOUNT. Specify
>>> SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
>>> __GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.
>>>
>>> Path: fork() -> copy_creds() -> prepare_creds()
>>>   -> security_prepare_creds(GFP_KERNEL_ACCOUNT) -> smack_cred_prepare()
>>>   -> smk_copy_rules() -> kmem_cache_zalloc(smack_rule_cache)
>>>
>>> Assisted-by: LLM
>>> Cc: Casey Schaufler <casey@schaufler-ca.com>
>>> Cc: Paul Moore <paul@paul-moore.com>
>>> Cc: James Morris <jmorris@namei.org>
>>> Cc: "Serge E. Hallyn" <serge@hallyn.com>
>>> Cc: linux-security-module@vger.kernel.org
>>> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
>> How was this change tested?

Brilliant response. Thank you. Add my

Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

> From the cover letter:
>> Each tested cache was verified with the warning in patch 13:
>> I confirmed that 1) the warning is triggered without the conversion,
>> and 2) specifying SLAB_MAY_ACCOUNT resolves it. However I could not test
>> io-pgtable_armv7s_l2 and sun50i's pt_pool caches due to lack of the
>> hardware and emulation support. So they are compile-tested only.
>>
>>   cache                  tested  environment
>>   ---------------------  ------  -----------------------
>>   radix_tree_node        yes     x86
>>   maple_node             yes     x86
>>   buffer_head            yes     x86
>>   skbuff_head_cache      yes     x86
>>   fanotify_*_event       yes     x86
>>   smack_rule             yes     x86
> Good, this can be reasonably tested.
> Let me write down instructions to replay this testing.
>
>>   io-pgtable_armv7s_l2   no      compile-tested only
>>   thread_stack           yes     ppc64le (64K pages)
>>   pgd_cache (arm64)      yes     arm64 (64K pages)
>>   PGT_CACHE (powerpc)    yes     ppc64le
>>   PCI_DMA_*_tables       yes     s390x (zPCI + vfio)
>>   hostfs_inode_cache     yes     UML
>>   sun50i pt_pool         no      compile-tested only
> # Pull the b4 branch from git.kernel.org and configure the kernel
>
> $ git clone -b b4/memalloc-prof-dont-waste-slabobj-ext-metadata \
>       https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git smack-repro
> $ cd smack-repro
> $ make defconfig kvm_guest.config
> $ ./scripts/config -e MEMCG -e SECURITY_SMACK -e DEBUG_VM -e FUSE_FS -e VIRTIO_FS -e VIRTIO_MMIO
> $ make olddefconfig
>
> # Create a script to run in a VM
> $ cat > repro.sh << 'EOF'
> #!/bin/sh
> mountpoint -q /sys/fs/cgroup || mount -t cgroup2 none /sys/fs/cgroup
> echo +memory > /sys/fs/cgroup/cgroup.subtree_control
> mkdir -p /sys/fs/cgroup/test
> echo $$ > /sys/fs/cgroup/test/cgroup.procs   # non-root memcg; root is not charged
> mountpoint -q /sys/fs/smackfs || mount -t smackfs smackfs /sys/fs/smackfs
> echo 'foo bar rwxa' > /sys/fs/smackfs/load-self2
> sh -c :   # fork -> prepare_creds -> smk_copy_rules(GFP_KERNEL_ACCOUNT)
> echo "WARN count: $(dmesg | grep -c 'WARNING:.*__memcg_slab_post_alloc_hook')"
> dmesg | sed -n '/cut here/,/end trace/p'
> EOF
>
> # Revert this patch, build the kernel, and test
>
> $ git revert --no-edit HEAD~3 # Revert "smack: specify ..."
> $ vng --build
> $ vng --user root -a lsm=smack -- sh repro.sh
> WARN count: 1
> [    1.178905] ------------[ cut here ]------------
> [    1.178913] WARNING: mm/memcontrol.c:3627 at __memcg_slab_post_alloc_hook+0x4a0/0x7b0, CPU#11: sh/434
> [    1.178922] Modules linked in:
> [    1.178925] CPU: 11 UID: 0 PID: 434 Comm: sh Not tainted 7.3.0-rc1-virtme-g121988b3e78d #3 PREEMPT(lazy)
> [    1.178928] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    1.178929] RIP: 0010:__memcg_slab_post_alloc_hook+0x4a0/0x7b0
> [    1.178932] Code: 86 e2 e3 ff e9 2e fe ff ff e8 7c a3 e3 ff 48 8b 53 10 f6 c2 03 0f 85 53 02 00 00 65 48 ff 0a e8 66 e2 e3 ff e9 52 fc ff ff 90 <0f> 0b 90 e9 ff fd ff ff 48 81 c3 bc 00 00 00 48 8b 0c d8 4c 8b a1
> [    1.178933] RSP: 0018:ff7dde988181bbf8 EFLAGS: 00010246
> [    1.178935] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ff4f87a042e55d00
> [    1.178936] RDX: 0000000000400dc0 RSI: 0000000000000000 RDI: ff4f87a041828b00
> [    1.178937] RBP: ff7dde988181bc80 R08: 0000000000000001 R09: ff7dde988181bc80
> [    1.178938] R10: 0000000000000000 R11: ff7dde988181be90 R12: ff4f87a045b600c0
> [    1.178939] R13: 0000000000000000 R14: ff4f87a04b95dc08 R15: ff4f87a041828b00
> [    1.178943] FS:  00007f5efb4e0780(0000) GS:ff4f87a0de940000(0000) knlGS:0000000000000000
> [    1.178945] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.178946] CR2: 0000555ab8c2dda8 CR3: 000000000594e006 CR4: 0000000000771ef0
> [    1.178947] PKRU: 55555554
> [    1.178948] Call Trace:
> [    1.178950]  <TASK>
> [    1.178951]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    1.178955]  ? __memcg_slab_post_alloc_hook+0x517/0x7b0
> [    1.178957]  kmem_cache_alloc_noprof+0x3ac/0x3e0
> [    1.178960]  ? smack_cred_prepare+0x84/0x180
> [    1.178964]  smack_cred_prepare+0x84/0x180
> [    1.178966]  security_prepare_creds+0x49/0xa0
> [    1.178970]  prepare_creds+0x168/0x280
> [    1.178974]  copy_creds+0x25/0x130
> [    1.178976]  copy_process+0x6d4/0x2830
> [    1.178981]  kernel_clone+0xd5/0x420
> [    1.178984]  __do_sys_clone+0x65/0x90
> [    1.178987]  do_syscall_64+0xda/0x4b0
> [    1.178992]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    1.178994]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [    1.178996] RIP: 0033:0x7f5efb5d30e8
> [    1.178998] Code: 7d e0 e8 2b 58 f5 ff 45 31 c0 31 d2 31 f6 64 48 8b 04 25 10 00 00 00 bf 11 00 20 01 4c 8d 90 d0 02 00 00 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 70 41 89 c4 85 c0 75 31 64 48 8b 04 25 10 00
> [    1.178999] RSP: 002b:00007ffce2898640 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
> [    1.179001] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f5efb5d30e8
> [    1.179002] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
> [    1.179003] RBP: 00007ffce2898660 R08: 0000000000000000 R09: 0000000000000000
> [    1.179003] R10: 00007f5efb4e0a50 R11: 0000000000000246 R12: 0000555aad43184c
> [    1.179004] R13: 00000000ffffffff R14: 0000000000000000 R15: 0000555ab8c37740
> [    1.179007]  </TASK>
> [    1.179008] ---[ end trace 0000000000000000 ]---
>
> # Revert the revert and run the same script in a VM
>
> $ git revert --no-edit HEAD
> $ vng --build
> $ vng --user root -a lsm=smack -- sh repro.sh
> WARN count: 0
>
> Hope this helps.
>

