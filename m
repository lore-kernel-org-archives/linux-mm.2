Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4506AC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 19:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC826B0088; Mon, 14 Sep 2026 15:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4856D6B008C; Mon, 14 Sep 2026 15:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C066B0096; Mon, 14 Sep 2026 15:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11EEC6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:10:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11F9012025C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:10:00 +0000 (UTC)
X-FDA: 85213307760.19.9F1921A
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1AD42180005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:09:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e01ckg9+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789412998;
	b=IxmKmcvOCzT7XQ2QSO4YtD9chx5xCNeLapHsp+6rGlyH+w3wFdPU0ZICY3tcMH5yFbBicG
	cjnLwNTG3moznHCQ4hcxClWnyb2jr+6iGmE9q6Xgsq0ACGSTj0ihzZCnzky702hE6bqyHk
	Tp9dmxktpQdm2dQxyFlzF6nTu0SasMI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e01ckg9+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789412998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9HHz7xqKOBgQRJBunlMxL3q9HNHJ9DU71Gm8Qozrv4=;
	b=RWMnUzujZmN3TG1QeMjaWQvmfamkF4ZALp0Pii9Z318CwwzlAJ5F1W/GqeJ4rMByPY22wf
	KBUS1woZkfZm3xtdBeInAan7+C8NJSiYydTR7X7Cgxh9aWGCBlgUlnmh/KOkfUOJ/1gSrH
	MrsIMRzeYslpYPS1DhLD21lcxte1AR4=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530d5fc2cd8so420471cf.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:09:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789412997; cv=none;
        d=google.com; s=arc-20260327;
        b=AkmIH0Pr6DjWIEaBJfrvH2LhBrIWFhzThXxtj/z8dsCWssKZsA7aW5vs3fWber5EdL
         YjZ3ycunYN7hZ3MhWxkAiuIRHHqRqnTmLZUJPk9rgrTHMWxR1W4zGghr7Z5EpX4VAWY5
         Z/v5+yKzcIVmsy6KQmIOh0sm7ihSWk/js1/cjcxANvWE953+9MdrcGHMTtuTjXhW/NYC
         aefsDQRaH7RIwPzqO+WN4p04QV2997t/cglZxYj5zcs7AJ3szMBiI5cU020yTH3QMG8z
         1gMRfDqZWyjiRlaEPz6KPMWme1+YGFtfw0vUCIl/7ta8EUtf14Zxc8YPBQvq4GlfZ2l1
         pjHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B9HHz7xqKOBgQRJBunlMxL3q9HNHJ9DU71Gm8Qozrv4=;
        fh=zyfFouYSeKRduqwuRjBbV4E6FrAT3HRCumXrL7dJxhQ=;
        b=McJJIy4gnxOv3q7RQ4vKh5sP7hhbkTP/u51H4GEfnwfHkZXIh/wTgyqB9HO0hGthEy
         V7woilBrB6csUGlrRKUBwEhkTdlPvRkmi2ZCxCylQFUDXZAUlBUn37Cpa5NgxZn+sHI0
         OQWT/6KoVU5Wo2jfWny2UwEpZ9NN4pcpspqyEZiUA7HbSrZDGKGJijC1G6/a7YsHImo7
         Tl6JVLqiaqB1XAfEnS8HEgSFzXXutHX5A8Z42vUpfe4frXkC6BruK4DLqBNQWepjE1B9
         RnrhCZBV7G2qt1qzsMeBo8D75aYXquYj4lDtzP8xbfpAgr6Tz2xMSP06RpZB+vW38RJm
         xUNQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789412997; x=1790017797; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B9HHz7xqKOBgQRJBunlMxL3q9HNHJ9DU71Gm8Qozrv4=;
        b=e01ckg9+sCCT/Y7vHfyPRp7bixtA2NNnXp1bRxgGjn9+uTA61lTDiY1BE/HRZCeAv8
         gKISKcoioH+QhNMmoJBK6WjGAEAQgkBHjxUwCXvAntbaU8JYfBAtkNerURNNqj2lJzXP
         CVfSOavvknFDAuLfiqGTy6wy0vtniJrhVPJ9WVm/PSQ/7e/9C6WuRFGMV2bWkaKKmQfB
         zbqf2/9YIBXekhgLNHmM82fcN7CfgL+JRS3jYEQFiDae1MXux3+wpJwb5r7Efv3wLrVX
         H1hLGNaiRlujWIF7xT+n62KQpNdvhXoiwGJQMvmOq6z+ObGlHPU0WquLlSzkuiuVrMBL
         a4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789412997; x=1790017797;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B9HHz7xqKOBgQRJBunlMxL3q9HNHJ9DU71Gm8Qozrv4=;
        b=a6TMh781kJPFTrgGxKecojJzEbJObRz1cwK+GKcx+HUOfDBNZcqeUHbZtJ2qpryhuj
         Vq5n6VWWUSnxAwvl2K405zwVmQrvw1NFSxGbnMk46kbvHNbIB0xxWT8b65Tx6hOlf3x1
         nFsbsJYAteUV2f65h3lZzTSTYL2sRmvVQDQbRWLTIT1Z390kyIgoOYCN3TW9hM8ueWv/
         5r7G9dCnjEUvaeGE5yFb6A5WB7EiLwOVYE0m3gDhGjHLpLEWNq4YaHlmSZ1SCAaFD+YG
         kVLplzofzpzzD4VHhp7/eTyc09E4WD/rAX0mucVPPDDni2xsu2BeQoXYBZ4tNXPENry6
         VReA==
X-Forwarded-Encrypted: i=1; AKwUvBzflp672qqRhgMh5s3piVT8BLdXpiiiuUVHnHT5yRnW3ch6OsWvaRgJ4odqf4hxISAYMPc1eCUCNw==@kvack.org
X-Gm-Message-State: AFuF++kz0JbbPdX+vaVOCx9A066nlB11wdnbyUaw222iXziyvAcy1epa
	xWk+lmd2Ge5o21g5xt7tG+Ze22U4Ih7ZWByxwKXR7j7rQSehzR/m9blRRIRUSYBwTljA/do8uOf
	LrO0Q9GtulToEJXNoXNRLSEDYe8XUat8qpH93uNKB
X-Gm-Gg: AYBFou2w5aYhzGdQ1ifQA4+ePVutS24GcVTg/ggMIP1uKIKwtr5XwqcQ3bYUGzLwozG
	vfOhnV4srEEQVP4uorL+ilbl7B/w6xIb7gnu3L095QZQ2hSc9upD04T70Gl4IEno0wBv4lOex9N
	S2ozJ0Uf65SdPSoCTwTCdVMD0xBh9JjbJOzQTvvZd2JDKLsN/0RMhrQ292BqKMRhbFRFQHdQkFy
	1eyov1T2smRygAJiSYO8af+a81i5xKtR/pdQhfQhF71CuyIDdOT/Qdi5kiDl07fwhqljorX0S6D
	riUyoa/CviOdCKVVZEFakbNnVWbnA1Jk0yrCUM+34pcnFzC7r2UXmDNrGh4V759Tm//Zf/yV+Pp
	d/6FxKEKdEg==
X-Received: by 2002:a05:622a:5809:b0:530:3f93:9023 with SMTP id
 d75a77b69052e-5311a5c4ddamr3464331cf.4.1789412996591; Mon, 14 Sep 2026
 12:09:56 -0700 (PDT)
MIME-Version: 1.0
References: <202609121422.hkKWuy7K-lkp@intel.com>
In-Reply-To: <202609121422.hkKWuy7K-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 14 Sep 2026 12:09:45 -0700
X-Gm-Features: AcwNN1V0cr3-51H8jG05tRliUGeoBV1UMLQnVvmfkEsxoTHflVeOK11wY4wInNQ
Message-ID: <CAJuCfpEzfP8nWnD2v6Wfb73h7ejD4NHNqz=TnXa18pvZgWz6ug@mail.gmail.com>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1AD42180005
X-Stat-Signature: m3r8t1opsyspbem5uo5ujxgg8uy57a18
X-HE-Tag: 1789412997-826675
X-HE-Meta: U2FsdGVkX19tQ9u39VUvQ+II/0ExqQhgFyx4g5Y5+19V6J8vp8UCQUGlXPsUErT0+NENJtpg1ozukE7E5nUeGRlEKGvpxtopsLtQiI+1DuXcxbx2fpyvdPxTzMRMGksdcK/NjS9m4SZ7yxgFsKmw7c+Q1ms12sn/TxeOxmc4gYki70WC+jAvt+0HTxZwe5tTP9GulC/R0qZEwtfocbB7PYLPmeQvastsbOvYQT7rXsoP91HzLGH3PS/xNtN0hTUJvKUsHTWhma3nJkpvuRkX7894ZfuLDmomxkWKGv0rkatpRWbI78O2sFgy8rq1gR6RPIDq6xwbyCi2vLvcvzSxnZ9ObHFgMLqpBnOoYUnsbQ68jG3hOgR3xExiqxbIcCvqaWMA9aKW5RSAhJc/SkxPkERYmcatrXGxY0srfB63gnPPujTlPp0SVUz0wlHeN5LCtxPms02SvM0EdstJ/0RAn1+l+EOhUEccUyMumw008wsGLTtSfZ6SfLp6WfOeNKdoAxW0Loo1bPeJlfNreXaksOpJXHnbmp1hQZ6mhgVZmKB/vqODV05+MWP2T3Dh8y346oRA35kt9x0HJEuTz5seSoSO3HkkMfWnMHdn5zi18d9Z3ZWqzrzhfJes2BUZVUMjSZtPrJ8fDSSw2NpR5UstcBKx3+l1prlVUnfNnJTdoVwTKKrcvF1/vf/+BzpzvXHmgVhm6i/yd3H4MeQy9t3yk6ytEW/KiGkNMdkA61PrQIRqgf8bIWWDiX7EvKw00KcJT4Auyu6ouFwQAI0bymLbvQNZHA66W8/jEJBaMPf8FqTkwW5jA5crmCgrpeiNeER2QahFtVN23lQfBS1kV+DpdcuWDGmA4zxVJ96Hxi4EInu6gX95u77RQUrt6+vXY2mzAoHKe7FJSR3EBBOwn9M7dBdXswCv0BCD9PMEMOcjYl/4lVUEM/x1O87kOEYhtyvbr20XKR0DKZ/jh0ICE3Y
 RROR3LN+
 YMV8tvCF3LLqmcSdKgxw+3NAuf9T3WP1YK0NNPKFRPvk6yxOFq3Zi/usW7G+3BqJdiFSG4oad/aeacPg4hEMex74yIA1NEHHlEqLr8fMFf6RgyGrVYiWr9jj1VKB0XWCwO1zcqCICUm23HlqqffZVu2w877FAXIExBCYOnjPHx0LzWDqwqV8PerPEzK7L/fxEA/Z46AFeaB+fLbA5vagX9kgXbOObti6aIP8gj8WnSpQTZGIBzjxOK29C0+RkrCGmqxh2FHKTu8IXhQA6qoMfsoFFKzXILExpzyzeIo04fld8xe5LgpFoMDJhXFKEpMwhi8WoxQcNCl7bg/Ax9iY5azdt8FQZJB+TcVaIsGj22dtvBMnmoqGAesOb6sq2WWMVYxZJedrGhMFNYTpwCToecjNjCZAV3SgDrwUXCJ1DWdxgnl3bg9TNJ++Q2w==
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

Fixup is posted at
https://lore.kernel.org/all/20260914190631.3167420-1-surenb@google.com/

>
> vim +/reacquire_rcu +205 fs/proc/task_mmu.c
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

