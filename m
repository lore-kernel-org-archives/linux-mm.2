Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BF2E109B46F
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5EEB6B0095; Tue, 31 Mar 2026 10:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B366A6B0098; Tue, 31 Mar 2026 10:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A732F6B0099; Tue, 31 Mar 2026 10:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BED86B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:31:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49D40160285
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:31:26 +0000 (UTC)
X-FDA: 84606596172.24.C54BD81
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6139940003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:31:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Na3Pm3oO;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774967484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cHhIod2Il1Dyv55t10VBMSrZQ93hKY5LNGG+LK8WkrM=;
	b=nSI0mt+B/PcLnjMLZidXaiB8cAKgAI5NJ0g/FVRXSqWcaDgpvDeSp0xkXOATpbZO6zZSue
	CJ1BBsMVlZKDKtQ/hwEha7dGqaBm7gO1xy0IvI77rijHxqhvhRipDJTYry9ikcSKCt2NXd
	yUpxu/obO5sswTwqp5lvvByiJwA8nao=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Na3Pm3oO;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774967484; a=rsa-sha256;
	cv=none;
	b=PdA0sRcfhguES+mVQrXTltwzV2fn4YAhb6UfxEI5J4ERaMQVDCMFkHtUt3dzf/REAJyEXN
	y/fHhS0YoZuN7yANSOfUvw8gESsWujnEeJ4Ap1pc2S77/qMgFKYfV4UMCTZLqduz3asx9P
	5I5qeW/zWEr5VXrC9XX/0vhmwCQ+7U4=
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-40ee9b945d5so4068447fac.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774967483; x=1775572283; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHhIod2Il1Dyv55t10VBMSrZQ93hKY5LNGG+LK8WkrM=;
        b=Na3Pm3oOagEOgeCbKkkZEbsMZirtZcFO4JaN7KmiDDzZZLaUji2FYb1O7+FTmNT8vr
         bILxb6f20vqUOtSEny9Bm8uJYTuIUwbIXKgZjM7phrOK9gC2iWUggO3l/TsF0SX3xw+B
         c42DdZIP2ICu2bFavPRm1+QLJ0efy7bQuZOXVk+5ZDr+IV24wH/UABezagUFKAqA0tTH
         HHOQG0hAiLnUwO2O24y8/KPo9fCtH/owo+caoPT5MRi9saOpWZwjyWr4RLOhuAUzc5t4
         RL5K7GtggDEx3gm6YtDw9Kp7VQxANDq9AvaP5dUMFXRrE8wujJdxgwlyOGayBpyrGMmR
         fmuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774967483; x=1775572283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cHhIod2Il1Dyv55t10VBMSrZQ93hKY5LNGG+LK8WkrM=;
        b=bUfZ7pFRhNnsIBhxvsa4pe3bu+gwr/kNox6zLYUqsVcp83qoZGnMrM1wCC/nTBT09h
         6RG3BL6NzD7hwtWZT+BjqItDAu3ejpHlxhFIiO/J0F6b6VxjYrgBtb2NUAU48IHz4xya
         Bqfl+RDoSs5e9q4uD3rH+LFq2UNqV9XixAvDvFhf175jTE2v/tn6HPKeyURqC8drWe3E
         Q3nWVoToitsjvmMKq2p8miBE4OLyNHiDwf5JqtxU0Y/2Xy4DBcwxY/YHcXrKTxLil5Cu
         /kTgsI6rlYGIsX/dP9160KVEjUgvOcQySB+LfqDkCrK1LDibEEQ/Ak/PbYS8x8wW8NvI
         w/KQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvcNADSzVexrdPO/gXwY/xTrss0M5NLvLtgEsJ2cOwJ1lUknb/8TPLwWMl2iSuR2H9ULcjbVaQlQ==@kvack.org
X-Gm-Message-State: AOJu0YxOLDbsnslakFhKQqW5SG+kChjQccOy1NH4xlCGsnqqfrt3MBnO
	6JzoscJCNhSe7cFx+WM1AlGwum1p5rPgsNWk481vw1hqXoQ/lKqOM4NNTYSpAw==
X-Gm-Gg: ATEYQzzz1hDUi3lpREc2nL4pDTx0jKBv8Cj00gc/VQp9pNO6Dy3HWjYfMUOsc1QK6Zp
	9+D45MFwaOXW9iHekcH5k5eRdWHTVVkT3QTgnhFC0B5MEjGgKaQ39Lpp/hV3UiaW7PlRsoWOhfR
	KI2JArecrc8ZPvXc2c9kqZNrD4KHnObbZ9Hci5HBKs2KonOtcOClkIq8X6NMkxXDwf+TXLlgB2V
	msyGzTjB88dkx4hfHjEi6m4aIfCQTr2UER4F906YsS0KOIOqmsUeEWJFcXldsOCoSs5P72gD3hR
	TCXQkPv/3ot1plPx6MmX7yDFYBzVsdXMzhn186DrzajciaqJac7KTZpFGbSq8JQbkm1t3e9NmhG
	JqbC+Tse4OAcdJ1gUIDdUJGa/KmsSYOyMoFFNW5GgG7pjaQovs5BZ4GiDkLVWVA1Yb8xFG/1lpA
	qKRlJvCn2HpgSYJTOwpzQC9w==
X-Received: by 2002:a05:6870:a11d:b0:40a:5a07:3598 with SMTP id 586e51a60fabf-41cec3c0ba0mr9664059fac.36.1774967482952;
        Tue, 31 Mar 2026 07:31:22 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d0e47178bsm7232543fac.11.2026.03.31.07.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 07:31:22 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Jackie Liu <liu.yun@linux.dev>
Cc: akpm@linux-foundation.org,
	joshua.hahnjy@gmail.com,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: fix memory leak in weighted_interleave_auto_store()
Date: Tue, 31 Mar 2026 07:31:19 -0700
Message-ID: <20260331143120.1531855-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260331100740.84906-1-liu.yun@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6139940003
X-Stat-Signature: 5omxcjyma4dfz69hd7kfixmo5jst3kfs
X-Rspamd-Server: rspam06
X-HE-Tag: 1774967484-907917
X-HE-Meta: U2FsdGVkX19+UQp71WeqV9p6PJlR3w/+jVIAA5vgXLPPCpYsODsjuZurEJ9+gF1k/d77uM6s78rGGpMlTG35ACnSB0a3QVwBAn8ZqJlb8lx3Yx8hacmI9tTBYM7X4NbFa0grCuROXWbVoX4/YJxvQ4dioZsQPyJfGbiI8wUynTySyg1AAbvC3kH2NdH3tvmb0QmKTIaSveBNCDU7JnUjKmzFJ1EqHbiXUUIsOiGdRl+eLEfP3KXURROPfJ9/Qws7btySB238VTcBZwKipXhHBSEM75yP3cnbIghr0TdaCFvm+MsbZsSwYBCK65/D2I1HEgPTaBBol+9OIKWk7aNRmpODiYn0UpPShEyfdBL1I5JE1dQMqCHBNXJcS84gFPVGF45ps41k7rlCkwv2EkTmFJFRg69IYrEwPktQMkqIDdfLxxOlH497BoUB7G9v/DgvGh3d4y0Vf5dE0/LA9sobuWk/+FnspRyL9E0dowxjjFGay9MyS960lhp7EvJ/hg0ecSmHNT5iekkYJDk8dNb9/ofPhpohH4ahkNbYBGrStrE3FHAKk74r7rCKlMEBo85hA9EFtOwPyEd9i7chqcsf3BPTy1w5XIRh1hyXGQDViAA89Cu0ryzSThfFGW8N77hGHDfNyXuFGSwPsvn+RhxCSUD3alPuHXb2z3Ug9COjBTnWsV7jen35z93OrK/GKgjrk3TlxmmXhFwv8QGXnTsjFKRCzRj92Ryf6cINBmOXDzeKfjUgBtb+xqjEZodGJTmHYkaFULsNS0Ul/aKSKCj1BGzNjR854I7fXCM9w4lJZowCv4mIPlRotYUz8s2Sembh7+yUv5hsXbq+n9EmurlhZYzFa0Vq58X6cNlaPW0YMRk9L65pbDyLQhi9zilYmEZkbXvVDmWohie5Dg6duBjoTczUyXSxPcYiw0H6IuEDq39b4yzWYj0wV4hFV8Q9GbC5siQECLy8lHV5mJCsl7O
 yokpeHdx
 RZfiUw9NaSPOYlH52sp0Vjc3xid5ehyni/uW/ulrzYYuxR6dS4fUBA1YB3wxc/bjUr7OoKimylPa4qwsMGegpec4XV31bLrQzIZUQAPCwOJKuaEgsOYN4sIvrUs5VWVPG4P6sRmZJusLnH3kylSavdQqi5qNPcIAcq2gAuGGM1dve9DBFR3i5le+znk4JsFlKsi2Iafprl8EIMzwDQBWKmX5CbOGVTEPP/XvDtjB24FoaSjLjLAl2+VmVUSY3LLj455R3uAxIHYmioyc222zJk+T1qWHvpczJc5BfjfawW/fHyxdp3rk7aQgqPHWF6FkKvo95/IFHbbbgZ+OMmgsLvBt6RQo4VMUSKpc/3Ifuz5PWk0cNZo3wwATn8xBsT0ZvHrvx97CWdIVnkKIXCZE8ZJNHmuSQUxA3CDD6kOXQHqMmHM5gRPZGGNZhW2SRqHZ7zDKd2M01IKym6l4+xR/k/YulbPtbn+drsJkFJpdaHhF7N92gpuG/L1/CqOL76wW30iwQaxHWF3UJk4MDf4diod9BOIjtqs1x2/1tpERpK4laVj1laCB9rYW+ZPRb1gZKsVZ4gkpGpzG2gjQoR/iA3ntZuj3uZsp1FGFtBYawY87JCcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 18:07:40 +0800 Jackie Liu <liu.yun@linux.dev> wrote:

> From: Jackie Liu <liuyun01@kylinos.cn>

Hi Jackie,

Thank you for the patch! Wow!! This is a great catch. As you note, the
trigger for this memory leak doesn't seem too difficult either.

Everything looks good, thank you! Have a great day : -)

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Add the missing kfree(new_wi_state) when the auto mode is already set
> to the requested value. When a user writes "false" to the auto sysfs
> interface and the current mode is already manual (mode_auto == false),
> the function returns early without freeing new_wi_state allocated at
> the beginning of the function. This can be triggered repeatedly from
> userspace, leaking memory on each write.
> 
> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> ---
>  mm/mempolicy.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index cf92bd6a8226..9ac74178075b 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -3713,6 +3713,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
>  			goto update_wi_state;
>  		if (input == old_wi_state->mode_auto) {
>  			mutex_unlock(&wi_state_lock);
> +			kfree(new_wi_state);
>  			return count;
>  		}
>  
> -- 
> 2.51.1

