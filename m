Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A024CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81E56B008C; Wed, 20 May 2026 09:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A595C6B0095; Wed, 20 May 2026 09:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F686B0096; Wed, 20 May 2026 09:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 864716B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:54:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33E17120324
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:54:24 +0000 (UTC)
X-FDA: 84787942848.30.7086C17
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id EE3D918000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:54:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HBwbQJJM;
	spf=pass (imf16.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779285262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gE3b6wCinhvGTxYfOlCOBpwr8sXmo/MKVQj4OkH8tQg=;
	b=PJX4HeeeGZi7sKHPsHX27BjCOCWRt2zMQ2SKlkUzwg4TM0XxfdFAOgcG4KFU1ljhrtpYig
	oaCRQoYlotdabK235nhuobY3KLvO+WhAVbEjahP4dRPpYtHdy9lqoG4IcVQDco4Sq9AJhv
	qyUy5TITngkd4NPaXzAHGKD5FpS06/c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779285262; a=rsa-sha256;
	cv=pass;
	b=oFKQRidM5aYh+EnhT5d2sM0CVFgFBn1HkxKwl/tW+Bh7ecEL9oIlG1wM5n1YRFMZCLG5Cd
	BDw7qvI/Wvuf/Yt5M2RcJZyL2vGdTnZOgtze/yqY4KvzGiinX4dASa0+IkkD9jyHSYd77g
	Za2oOcMjvyyf4FN/wXgTnwLz5IgN3Bw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HBwbQJJM;
	spf=pass (imf16.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50e61648f10so17681cf.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 06:54:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779285261; cv=none;
        d=google.com; s=arc-20240605;
        b=j1zWZ/h23ScCqn+Nc5DRHHnSiSfh6LWLws8Af7y6OeXvgjaZB2gjV8TagmSNP7b8WY
         oYV2chPwocsTKN6R74xVk7fUQ80qqJjivhWtwx4jAho4trjKPBtgbHuBNNyyxb8AVq3d
         4GdrdMiebp5e8xfozrkWG6J9+8XiKa/El1VO51BFLF00ljp4ehnBPqUlHg+MG2PuAAh5
         wuX0tLu/5ymJJk1bRB4GcQO2bKDYjGY5+hsBjhE2u0DN42F5MVajOk/EGDUUfplReSOO
         S8hCIoEZNlEKKdb95KyP3r2aFjGJUdy1YFwOLaXNa7x1vPdkr/zzpBMAUy3usJQtX7Bj
         xcQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gE3b6wCinhvGTxYfOlCOBpwr8sXmo/MKVQj4OkH8tQg=;
        fh=Nduc/rrutFPBR6QBaHKxbOWiHgeSouE29pTZ6Zl+1po=;
        b=aFrfDLRPHv2E3KjOY19CwTP4Q7UEmku9P8fVJV/faZd1WcoXNCYsAZ4gD5eu/25cbb
         o+xJteztO0RJQOY8QZsQHFqqL2uFRIrEe2GDuMUp9NYuhg/6hxPqJWDv2/02evOyDvSy
         vSvT6UktF/g+5Tz66wPmoQ/RKV2Wj296kb7/inbksnA2eF44VyVbiRIoZVxOB6SkBFTw
         7KyPWMV87YHHcRpkA72bDAK0tv2yw38YlHDKn1H7p/o8fn3zp+1zpj3/WYRr/r0wd9bo
         7uYAGZVSG1yWVvgBm43Im+x+fbWONY3erZWmNn9MjltyzvAc19PBRwHk0cVvFAbxmJie
         EQ+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779285261; x=1779890061; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gE3b6wCinhvGTxYfOlCOBpwr8sXmo/MKVQj4OkH8tQg=;
        b=HBwbQJJMms1OaVqTdkqtis/GiHjutqMDoulTV34LlWhJTo8JKt1c233roE7pwiqqgH
         CAUPcWVIVtPaO7euIG7ed4e3WsGxCsmIOb5ua15fba9o/KpzF0m6Z6b86cNI0YqVyp7F
         oaaK/wboDGn/0xwviIFMzK8+m/O+fQY+g0KZ7JQS9Knb5ouMtvCR5F9BLMG8MiVFJKmW
         P8yfBZz8UI8vhiVlw8Ia8Yn6DxVa3RDLbCcNuK+sslzCdtov69gB4TY7SD0+FYysyK/U
         I7RanSG6HtXbhCtxLYGDgwA81kYt4kdHZPKItnyitQg4BThBUWgYNBripuIxz6RP0+ld
         kGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779285261; x=1779890061;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gE3b6wCinhvGTxYfOlCOBpwr8sXmo/MKVQj4OkH8tQg=;
        b=W/TtDdv4HE4FRicQOd5fmaGXjwEV6z+1THR4uXhMiyWH8WHx689VsPunqRodtX/Mir
         OTx8gzNd+Wjv3JP6Na0H0E/SW+NKnhAcwfu1tJ+EISCxqfUpZ2slz2w+aN289G+0vX8d
         xpsFTgQt97GClsxL88oRPdRhpEKSY/KPfXttT4haiHQqZlxTLKj9rtTew2b7QZQj9kfr
         h3JPs/mwDNgWua+HejEHwQRmYBJ8ogihKcXIt5D4WQmA2j7hvTbl8AKDOecUaxGALTV7
         G5aOopATxrf+AYmrpn7Ec89sC+ISaW4SIi3qonjr6G2Fk3krwoFvGwH3/ZXCUMMJrTQo
         Mung==
X-Forwarded-Encrypted: i=1; AFNElJ+eP7Vevwm+wIUH5c4XJ17VVLwFjpP8SdFQWc2VIL56RcJdPGMKlXh3Rz0FN11h+NfiL5mJM3loPw==@kvack.org
X-Gm-Message-State: AOJu0YxSE/Ww9IN87WT5OYqyn5Ngj+ZEQ41/UOHOkaRzr+e5MSclZ3as
	82WMwlfNjzvFW71duZNsZivUlTgRWYD5kFnxo6yIQ18DNHaLwJGxhboOu1FyPpLZJR8YKnLT5iq
	ePeOeNXrpttBiDIsjJ6zZ2H9Io8codp2hmV5pSVrR
X-Gm-Gg: Acq92OETkOfYs4FOM++x30okmhdbKw047Wz7+ltG2LQh5+BgSBPWxFhLZdybxcJaAUR
	BwijombcsdB3C97qWm8B1AipwPaJlkTAYgWkBZ9LEhVPLEx5tY7KwQHl5kWauZ0vN8iTkWnDsRi
	KU31ymYA0c7fGROfijiBY/l9Va6gFnzanV1C6bmRWIZ2AAO/+P0qo0Y+CVrpRQOTj+dETQlxwtV
	eMuD0GfJU7PgMN0wILQvFKlhat/bS5oDmcFzhbdoCuE+R/n+xEQEXPSgOX78z60QKZ++13HAji3
	0omVf+ckfDjiQPerIEFXJzlwa+O6mA==
X-Received: by 2002:a05:622a:4248:b0:50e:38f0:ccb2 with SMTP id
 d75a77b69052e-5167b6af157mr20549601cf.15.1779285259966; Wed, 20 May 2026
 06:54:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-9-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-9-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 14:53:43 +0100
X-Gm-Features: AVHnY4Im-a3duwAXpFrRqgO3e6bv1dT8inf454bQ9t5MibC6MZzfjT5fwn9v5O8
Message-ID: <CA+EHjTzd7HrkXyXdO65VDzUg3mehBoajRCS2XBU4ogK+JCuX_g@mail.gmail.com>
Subject: Re: [PATCH v6 09/43] KVM: Move kvm_supported_mem_attributes() to kvm_host.h
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EE3D918000E
X-Rspam-User: 
X-Stat-Signature: 71t6tj69xjsoj6kio8gdisq5fynafdpu
X-HE-Tag: 1779285261-481400
X-HE-Meta: U2FsdGVkX1/gpB48PrfExl+bQFBx2EYpPEEaXaZjhk0dCPBCBLvHRu9i7Cvw9VH2Uzd9/l447bOHSCLaN32+J1oGp0TgzYYN6aH0dFE0fqmLzEe3cPs5yrC0a/r4XXLU7lmOuxukpALl067H5ZxTBxGPfU45lyDqjzkgEWOe44VUPSN1DxCi7VB3OpIHyMup2zwWtmZvWV4ViGE8oDFHpdMnnWemhSRdjlFxhkN5SdggDvBKaJzloA7mhkT2XDYqSpNuP1KoPFw10hqI80msBNr3jN2ul48pm4Xjp77yOAkwh1rHbthehfQJBjAbKLHRyx7Cb/JWV8yMZogJHHHTEhViWldZvDeyS7wf7xE/bt/L1aDL0hNuoN0+YeZWkrYXQzjEHa7x2x2Mf16qUntbzi1i4RfgzeZEFWUoC0oWOdH00AM2tm14xgC7EybuGF6vvbYDXb2x6LPp0BacilCNFTz+TtTd3uvDcJs7wXk9zTTaYM07wWXXwXSWL3C/W/qX+jHHJyJv/PrWa7Zvc34rlYA2dcCY9ChfOlS5CMIfSLeLrb7kAgAQoFBKeKYoQbqvm7PIUq9/UsacoIpCz21YHc+rj8C716oUGEtrtyCzso/1G3UfbyAmE5y9ves3xG7fZsNXLCXcy6a/WR69GVbIPs7heYgtbKwblVL/+CUanrRtxGAp1CKgBGYpLfLPhVTGXP8kWlBb4UhvfiAXGYRRTtzNcKyZ6AcMC4YOtuGSM1i+0qgNAfyekf5fTa1HOEWsb2oLWnmWAYnJSOTGNFioiqkjHVBAuZTd9T2NzhClHegMAbweXxOTFvYV5cdIn9zbLwyq+LvldzhaqBbYcvjXHd9aXKVAyLKplzr7TEKpptGgbH1Y4NK0VUH/DaMPXNgJIj/Kl5kQ9NUvA/m+AWfgPfprX308siYUMuZc7dGa7ncEXG53Ksg75SF+ZslWjkKRU/yrDclEldRiSQY5OPs
 KNdu4iyj
 7KMIt9oyfbiWqZdcYfsPzjYEnTlafOT3RhZgN9fu1LNLCPFX46j8lqOPq6gzkMXL+jcL6JcX7YWOqybxEHy+wXyMJDgx7+vtrzv7FeCH55BdH7nNZeQaS85KlJZsjBq0Y9tY33Oc2hJaGm5SrzKwTND7rM8NzUYAQxfTcdQLWzV0WH02RPAC2Mvm1bwZnUwglMqSH7V1x+3ePB3gEnFM3FPFjiPY72AFC+/iHNDZDybADgnhDlc6W1IwoinWjrGcXH2+P13K7Esj8Cn1Q/tAOS2j/arunc8hCE6LKc9xdowOW0FHLYlVmIM50UQRnVx/MaUPQ21mGkqfsfwKSc+Nw410qCRpDYprpFYBNfBwIrnCGWRQHTcLpfEiR1hIx4QD8OVIYrGhyfAMI3sd6NmKsa1lXOEzwWnPhhfdx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Move kvm_supported_mem_attributes() from kvm_main.c to kvm_host.h and
> make it a static inline function. This allows the helper to be used in
> other parts of the KVM subsystem outside of kvm_main.c. This helper will be
> used later by guest_memfd.
>
> No functional change intended.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  include/linux/kvm_host.h | 10 ++++++++++
>  virt/kvm/kvm_main.c      | 10 ----------
>  2 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1deab76dc0a2c..f9ea95e33d050 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2529,6 +2529,16 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
>  }
>
>  #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
> +static inline u64 kvm_supported_mem_attributes(struct kvm *kvm)
> +{
> +#ifdef kvm_arch_has_private_mem
> +       if (!kvm || kvm_arch_has_private_mem(kvm))
> +               return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +#endif
> +
> +       return 0;
> +}
> +
>  typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
>  DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0a4024948711a..ff20e63143642 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2428,16 +2428,6 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
>
>  #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
> -static u64 kvm_supported_mem_attributes(struct kvm *kvm)
> -{
> -#ifdef kvm_arch_has_private_mem
> -       if (!kvm || kvm_arch_has_private_mem(kvm))
> -               return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> -#endif
> -
> -       return 0;
> -}
> -
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  {
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

