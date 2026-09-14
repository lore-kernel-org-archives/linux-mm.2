Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68C83C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BCAC6B00AA; Mon, 14 Sep 2026 11:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745D06B00A9; Mon, 14 Sep 2026 11:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FE96B00AC; Mon, 14 Sep 2026 11:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30FB16B00A9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:02:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA3D81A0178
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:02:02 +0000 (UTC)
X-FDA: 85212682884.28.78734C1
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf29.hostedemail.com (Postfix) with ESMTP id B5B42120019
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:02:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v8jRv9gB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v8jRv9gB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789398120;
	b=LfVzET+UI6ly0ouuqfb7Y2/JZunz0i12rMA8ie/bcLev9Xi1jz8a69dFx7gJ/kymGjgeHL
	nIASth8Bje7YxJsE6R2p60le7jkALeYErFlXenQvT2hvUTy7I71MZ52NEYRJ6uskS7ma98
	DT9+3fWlZbLIE4KcmaB0r8MpKUAxXbA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzUqKcWXaytoxZ9VR531dfCrQ208kTEYqL04RpaAkkA=;
	b=K1b/C06gjc5Ijpoe4uyEsWMPb40hw6QbEjnOd7wnZ3czdwwR+P0dSuMUIs9Zcz6JMB9A2Y
	xfI5kOLswCmBqwxVBkC9y1p2nFeN2TIrT10aRtCD2erGehpV1IV90Fhzj3G0shzD0fX7GJ
	sdiOJmQw2ITWMqFREdDsoEBHn5lGTPY=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530d5fc2cd8so326841cf.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:02:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789398120; cv=none;
        d=google.com; s=arc-20260327;
        b=UsE5R1GzsdfPU4GkbZ05wFLsN0d6D/MX+w6uTK7hKx5Ebep0B770pJkKjnE4hQeI2D
         /g7rgU6MfzxkLi+WU1k452lQ4lbOFVAn7EKC/6wuDhHn4LN+xGnz0n5KgiVsJztvExZE
         1iRdlKVGypLSMh2JtdqOvgLDl6W9v3LTWEd/Rxnn39fcWXPYEAjvrpcc7nW+AGiPOBef
         NNJBeDm2SZfTAXx7W13YZOJQpPgR0i1VbWjNec8BHoIpXK3FxJC3vaH+Z1fvf4h7SFq5
         xdEzHYz6g0B2CwyketihYglVcK44as9qiWHPgbWc23ROVEmwTSORfBvEsFl89NQk/W5v
         BcWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PzUqKcWXaytoxZ9VR531dfCrQ208kTEYqL04RpaAkkA=;
        fh=SkxUxWUA2kojecgfbxrrjHbMWawvE4EfuBtqY6BtJKY=;
        b=FDq/0GbZjpGtcbKf6sr6lrKm4fwV1gwZaWAz8LNEscV5hQlOLC9o6byTUx1QlzF1Nl
         zZcHr4qoixTe5W5IG3NHWY3W2mfHI10/cLwOYW9S+IlG3Z5vkGH5VQ/ln+VjoFsCBSyC
         xTXRj48Y5gVmxdRn4F8UWHeI/VkAUOLDDOjVKkkfe5oOUNoC/eFF07N1Qx4a8e26s4XU
         Eej7lCzKxm9q+VWlwF/z6RNrXpiLpgBtfhC7F8UYzSaIQgS/snCY0nK6gZNl6A9vN/hX
         heBI2V0sL97WJGlOJfqjymNAhxXX5G04HhY5XAXcNtbT/YLG6+Nx/8rLr61XYb3knUDK
         2tNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789398120; x=1790002920; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PzUqKcWXaytoxZ9VR531dfCrQ208kTEYqL04RpaAkkA=;
        b=v8jRv9gBywYQ+eJRV5xcVIFMBlSVUbVkc0KHutEQuwPA+i6ACfEU5TKYyYG+6J1rAl
         KpRF2uZV+Xm7Dd46xayEb57AqJ+TKNGJXm5tLsv6wR4P9/k3DaLoQK5/XsgnAytHM3p/
         rW90vQMwXbpoDOd7XQrb5X+P+EPN3flOI/QRtDv7OKJyiQ6WkD1USOLe/zCPaOYSqdtQ
         UCzpYqtx4t+YHQI1szYnIOxcFeVuN6DoQk5QVSZp0U2oOf7uAlXLI/ebn5mUzQV3jhQf
         UAvqYF8EyTAO5OueSJ/udnmu/LmvV71NAuS3Eab0YBvtOZCGR6+LKPuGQIzjKmn02P2J
         PPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789398120; x=1790002920;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PzUqKcWXaytoxZ9VR531dfCrQ208kTEYqL04RpaAkkA=;
        b=SNuiOIeecCZnbFFPIT1lHE8hylCP/ks/dESYlDA1dvI/AwEJ+dweCOdbr/RrFrfrHf
         WCfAhJgVDyRMYWl5n411eVpPnR4Qj6be1sqi9wJiaPM7UotFG8ogbfFrIbirLx9vC+Aj
         YDLwMR6wREYxqOjHebLnxTZUgUD4VXW/qExAHojJj4I1iRWHRVGJvmsCnRPOL1qjcuE6
         5dbHjXt4CCNvBG/ZdKA6F58NCnHi97VUgGGEr5wwK2r1qcZ4rzP6/lGSLAMsdsz+0wD6
         hfPAmp6yGjO0X3TzPpSNpQgJAEpzXl6m2KMVz5P2rHvJliY/So88Cu9/dP3PNEi46C1l
         kB+A==
X-Forwarded-Encrypted: i=1; AKwUvBxOsVhXfBQ7nyuAyoa6xThN3dAzkri3qgF/2JJZs9M6pBk9cVoIQg6EnQHdguB0zaXDPFhjwpVuig==@kvack.org
X-Gm-Message-State: AFuF++mfsGIuieHlMTw93dBaz+AesEhdqz6hFMLtXIV/tXpH3ZGY0BdD
	K1rxsdANLwBf4robusp9CcxswFXK6cw9lM6A+2yTB8Chr8GjPzEhymWQhR9/XVVgYAQvFhN/+n4
	sUp6R5IeROkU1KxcbB1sYY4ehPbRnfe2fJEMDT4gFSwO6DDUOL7z+B2D1/FU=
X-Gm-Gg: AYBFou1f+YR7vU0HCgAPy3y2qCEIB1SLwTr01gQvJVcSn8dt2o4kSvHpzuMFwUhN66h
	6WG2AFuyuqNf8+XeGxyYiMceVanxS5ITBMRTAl8jWN+l/0Ml04w4xb7cHcMqAWSlE/nTv5ZthZW
	NZpkEEwPfJ4Gna8e1Qd1p9qKYMC/FiRRq4IC4ZUboCUtM4CcUy2r9SC4ONM3qbUsghrBO1W0tfV
	TCR2DD1XribqxHkyYggB5FkFko5kh/WgXOwXYIOV+HWNUiwTUoaLtdgIcg4a/oOi3xlZp/0EnuF
	qEzIdPM46qAUcp8N7M0t0F68Sby7Bc8zXPvrDte70vt6KwNwM5OBXA==
X-Received: by 2002:ac8:5a0f:0:b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-5310ee4bab2mr9559071cf.7.1789398118911; Mon, 14 Sep 2026
 08:01:58 -0700 (PDT)
MIME-Version: 1.0
References: <202609121422.hkKWuy7K-lkp@intel.com>
In-Reply-To: <202609121422.hkKWuy7K-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 14 Sep 2026 08:01:45 -0700
X-Gm-Features: AcwNN1WLIuqFwJiP12OvUDtNJ_un5ijm7vW8SviOfyPSvZRrA42nxpsFR-V1QmA
Message-ID: <CAJuCfpGoZTELakrjKw1Up0eQnSTgXnuhADeRrQKPV+xPhtRy2Q@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 439/459] fs/proc/task_mmu.c:205:13: warning:
 'reacquire_rcu' defined but not used
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	"Liam R. Howlett (Oracle)" <liam@infradead.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B5B42120019
X-Stat-Signature: ewfuxuwnu5kbi48mkdspexph1m7r8wb6
X-Rspamd-Server: rspam01
X-HE-Tag: 1789398120-141650
X-HE-Meta: U2FsdGVkX19+xqufcwzspcXnSpKB9UCHQjxd+JcNNfdN/80E2KwWefuXkpG/8t4o+70Wg7kNlhtYlKFmIBOLBLJgwkdR2keGo8wgW0snKmGmIZS9/TnQo5d7PFe0G+/URr0D9s7hhk9HdLqYOX76Wahi01caQGUaPOUgPNH473rzKhUGbMovbs1hEo1iiXoFaHaYqOViGOjA3xi7hO6D6bEK5FHqxKkA2yUxiUy6UZSSytAMjd2pT4UnMhF/oogv+9UeB/rgEU9Eiw8B6fLTzdcNnfaCnxW78xzGmfemssVX97bDAnK7T48b84egkc8ZNGxuPBPE3MpLkIH75t7A5iUqzQOWRy6SNblnk8vOsGSjj0Bevmz7yLMyufepUxloO3RRlhLjzviJiUpeQSraNGe0jlIT+cqKbcVGZz/5rtyuh+7l+XwlZhnD/KgW7aZHwHcJLHStDDs9tJm1pG7D05tyU7EhWrFVvBctx+mFQ/zDlgO6xo7otW4F/9X6f3hddVNtKeiiwi3fOXkuFDc6gLCLE6XoVFcmgBTk88QxIN5DGXBlbXoz6vRmoaWVqBUeMzPbcnZjnO58dktLPFUOgf6H9RU3rXtBO+SLbWMEUEFTFa0t5TNwy6Q/INHMsTVoBUaqQA/rBEx0oDhoCBTDHkeLbonfjneqSSR/zA3ZFJQdBMZJnwSocyJ6uXO51ZbdtzWChDj7ljy/N1IPKulQKD6H6Xpeq/07731baBAgfvrTweimfvbRTgiFz3VbD0hWdw+3cvziSGuygc1i8BSqtziMwjjENxXZg4RcKZjZ4irVV8Vmiz318Z8SrurdTdGi4zrjb39i5CT7PEaRTgBx4XmHQEvx/SIpIbRc7bScC+RxHkspo4FogArd8McgFYRLy8Zy75jDbwnE5JdsbHKInzokU3NCHMAV+YuhU35djY/jqOaPo4hOBJ3IElapwPoTYGEnMMaO2MstXE2ZeNE
 iH4rs+34
 WPmMAAglSQf68GzX6UgDZvwZFM/Shys6/DQ8mIQws66/av/qwWZ5vqyTQrl6p/R1811Iwq4QoN1hL8PHct1GEQd/8oZI8OYIXMd6/5gOW8zildr4umFqbQKk3NhBXvXR5zwyMLcK8UPyFA2vrj+oIQd2kA7whEgXJnjN84sz46MwxyfpLn9UIe146SmlHRkCIbXVyRcQ4mVfKnBAcan7ZOo+Vlfi/zlSUtTOIX8AQNE6T+Ch9G+b/2TwnUbPjgzK/YBd6Hn6WZA18YdgTFwTE0RZ6RHkh8sqo/PCRphgOgI3U/bIaxnhppS869FboPJ+qK2vC8AZwfJoNDmpnKkjSyzkrj7Yu8XoUbKsEp0vhHwUS0nAcMOLTlymYq7RsNEkJk87BnbrPldHJo4j8LhZXAkd5ze5d9scpNCWK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 5:41=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-ne=
w
> head:   383fc05d4650b021f3c17e36a145106dcc61a294
> commit: 2a61a4b80dc01581dc9f6935eedefbd596e77409 [439/459] proc/task_mmu:=
 remove unnecessary inlines in function definitions
> config: openrisc-randconfig-r053-20260912 (https://download.01.org/0day-c=
i/archive/20260912/202609121422.hkKWuy7K-lkp@intel.com/config)
> compiler: or1k-linux-gcc (GCC) 16.1.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260912/202609121422.hkKWuy7K-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> fs/proc/task_mmu.c:205:13: warning: 'reacquire_rcu' defined but not us=
ed [-Wunused-function]
>      205 | static void reacquire_rcu(struct proc_maps_private *priv)
>          |             ^~~~~~~~~~~~~
> >> fs/proc/task_mmu.c:197:13: warning: 'drop_rcu' defined but not used [-=
Wunused-function]
>      197 | static void drop_rcu(struct proc_maps_private *priv)
>          |             ^~~~~~~~
>    fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not used=
 [-Wunused-function]
>      133 | static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>          |            ^~~~~~~~~~~
>
>
> vim +/reacquire_rcu +205 fs/proc/task_mmu.c

Looks like these functions are not used when
CONFIG_PROC_PAGE_MONITOR=3Dn. I'll post a fixup today.

>
>    196
>  > 197  static void drop_rcu(struct proc_maps_private *priv)
>    198  {
>    199          if (priv->lock_ctx.mmap_locked)
>    200                  return;
>    201
>    202          rcu_read_unlock();
>    203  }
>    204
>  > 205  static void reacquire_rcu(struct proc_maps_private *priv)
>    206  {
>    207          if (priv->lock_ctx.mmap_locked)
>    208                  return;
>    209
>    210          rcu_read_lock();
>    211          /* Reinitialize the iterator. */
>    212          vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_e=
nd);
>    213  }
>    214
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

