Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F77AC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53C5C6B008C; Fri, 11 Sep 2026 10:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C47B6B0095; Fri, 11 Sep 2026 10:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B33A6B0098; Fri, 11 Sep 2026 10:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 154E86B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:35:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D5C61C1C64
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:35:13 +0000 (UTC)
X-FDA: 85201728906.11.33402B1
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9BCE11C0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:35:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uZyY9GK4;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789137311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkVCJuwmBQSImGq06egfb3qFzategRQekOyDcs9IwJg=;
	b=BVyNwl6MorcP/L9XLDXmnyvLm7at4lDmKxfVy9RJzicZ4L/lcAFE2ZMb5EyUnku5WDW/mN
	X/EhxVYDw+OHWMHpHmXRJaIMt3YqRK+7kc8b365vW4GDzm67plPEeK9OttKW+oJCK6b0jc
	Bb3BG8ZQi8grtTED71/A9YnxFi8kD9w=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uZyY9GK4;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789137311;
	b=W3NhoNllnoOassJQihH3Az2z7cQ5psAivvnjivlhsX4hJBOpc+2Mbm/5z/0pdzWH9n6s+k
	Bb0R4JRggSpXE1nZwIc0DUwiXT2Rblt4SPXvlitoOB4y9iyf+UZwAUJGXNHvOEsmhV1SVs
	1r576XyS/fCuO0wiVea2ShNcjHhRL+c=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so5691cf.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:35:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789137311; cv=none;
        d=google.com; s=arc-20260327;
        b=QBADv+aanleUG18M2HnoEhUoHZ4fPeRBieIe6FU3ur6hitbdgHpTZGuHLuzDWcy/er
         dOq6+Lf+ZItGKaer1EaQ7ufMJrjF+qNI+EGJF+Gx2t0DO+fXpzAhcAq6dr6XJ6vyQLvw
         wxCKQq8/zGzNFqm1xasUR7+YC9i1xHqDi9ILy0hFsCK6E2Koz53LewcPBgVxRL/S6jay
         vwf4tQ/dBqOx7i2jiT2TQ+tXLow6D1uTXiJ08h2m/rGOLsz8z6Lq04/gY5uv5vev8m3B
         VVkOGJTR5jakedgW4PCS3gAJ3gIPcJixULdMqo/cit5+52r8pa/EJVbav73sJZU5Thyh
         vVfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OkVCJuwmBQSImGq06egfb3qFzategRQekOyDcs9IwJg=;
        fh=jpVuREP8zZfbj9Cqcmcb90ZggyyYD7b1vwrzK1Tm1QI=;
        b=MPWOl5SeBr1Jti4KB31ftm8YTiNTMqxP4+YFEPKSiV0Iiuv77cTOtKWUHZmFO2WBAR
         zHD5hOYdVTjpZP87DG7/OrrfnfP0R6evfrJz3g4SRSlS2sRXb5znWzXqtIUD3E16Dd0X
         Mzffcp+7ZmsvDGbKQ/uC68npwGbYELXZKvIpP9cMmMR+8QWHu08Fz4nnRGVLk9oXw694
         L4QfD9PqGIDhX4a0/Bl6lE6Uw3z7WStCRiNQiSMlo5ojGb19wtbz1m95ImEyyPy6vAis
         Ib+2LXXDM3f9mk9JNT8gRaFBbjz6nK0Zp6+MupCLNUCcv8IwgPQhr5o8+KknA24njjEL
         bX4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789137311; x=1789742111; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OkVCJuwmBQSImGq06egfb3qFzategRQekOyDcs9IwJg=;
        b=uZyY9GK491KSInMJbvPlHNHGditt7iu/fQhdyox41vgRIYB5eFbMwUZ4olcb5WRj4F
         Jtp14iJYscLWPXLaWXMEXE9Zt1OLoRxxQEex0r5aLYEf8VzZtEh2ggUY3yBfazIcjeDC
         YIAHU7z1sq6RtZiapy5LGZTVkNf2P5bmMRqYueqK+7eZumi0chrGEHPRQe3L8xSR7LjP
         S3CoTkClkNGPRYsTAVgX7iJzCqlTOSWytXJIO6O0TsCQmEqpANqAKXmNWkwI23I81TiB
         VBhtOKXKq8IWR1aF8g9YenlWuiQKKRrdHLpd8SVpoIBMzuoZYV4ZuH5y0gwMJho013sv
         QbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789137311; x=1789742111;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OkVCJuwmBQSImGq06egfb3qFzategRQekOyDcs9IwJg=;
        b=JtNbrPxZt3c2H+SBceiCZGPX/xfs96nOQGH1nYPckLLshLb/UEmbYu98NL/aMP8ZZC
         Gqd2agB1gLuW1MmPMce8bpsqwqEAsiaaOlWEcybAo/q9/qcYVfskegGcKMiRUYiCIIeZ
         nf1+xEWOmA+ZaBM5Dqw7KW1hq8FxOepMDN6qNZfPGNtt0s3VKNBH/A6DaOGYZqIBgb2X
         us+lnFvfyL1oW3ZCoVPI9IcqpP4iDjajv2bd3lKhYbzJp+gEbOpXV8elZYg2MncLe6jz
         pu6OhVh5E/O/i9hJNrxdO5E0/n1d1RApDT8L4L1VwMhBUtQihBJ3y5CBTLepqrE+KNUt
         LIAQ==
X-Forwarded-Encrypted: i=1; AKwUvBw8JKFndC//VIAhhsRQb6LYSUkBDxcdzvPrKIwtVrLJpmQsmj8aOiE+klJPvTDzQ+jj+ZrWAVy/7w==@kvack.org
X-Gm-Message-State: AFuF++ltXhxKn/3xOBmiF3nDpTfBh/KVRj2PL/MPZmoLNi4LOo2hqFv+
	Y+4I0HsZhKKczGA3ouAxMFrapfF7fIngp5XO2bYh1jflYrHP5RprByKMhxAu/7Fual+AYXEA5/A
	jWhGDMMhPfybwJvkd2LGuc/dtHtKfb4d2fyiw6rt5nW22rGVGIfGLPvSp
X-Gm-Gg: AYBFou0iVUmwsnrOCGzxEdcYmX1sfElXnX0ZqJW3+uxiWMgISM5HLWDhHBi2eRblSQR
	H8F4syK2xHl0Dl6ZZ0s5a5aOt3SDhPPFyd8HN7JBlVAhPRuZ4e+JmVsBjD8ZZ7nTN8Bx5e/1ZS8
	3VqPmUWb6eNwj7+oH7XWV/ZcFtzHphPkxouCgf9q70upUQ9JnQTiv49J0FoE4nyFhz8DUPp6/s8
	VIr82gZppOiBQ4k+2lOhxNwhD+2xuWRwPkjKxi9Wy23VfPaSCik2LVP9rLjKnpPo9OJHOAR23b/
	2dQ4/iDmYrVVZMRcXDOoHAueg1udRbeWytBEkAYpKsDx3udUp9PINw==
X-Received: by 2002:a05:622a:999:b0:530:5120:19da with SMTP id
 d75a77b69052e-530c93581c6mr18486911cf.2.1789136903951; Fri, 11 Sep 2026
 07:28:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-2-surenb@google.com>
 <008dcaa3-2068-46e5-9e58-afb590d90584@kernel.org>
In-Reply-To: <008dcaa3-2068-46e5-9e58-afb590d90584@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 07:28:13 -0700
X-Gm-Features: AcwNN1XuMz6tXlbjt5zzQkbqGbZOBrpxgwA9ACDwXzvAZXoq6Qjcyr7XzcP7kj4
Message-ID: <CAJuCfpF5CBrCxZWm+Luopf2gq_hHxsbw0QptNhfRT=+KjyWbJQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] proc/task_mmu: remove unnecessary helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9BCE11C0006
X-Stat-Signature: d3w3hpq56xyg14ey9iz3hm6aj869gb7e
X-Rspam-User: 
X-HE-Tag: 1789137311-718045
X-HE-Meta: U2FsdGVkX191sZ8T/oCh+1UVbpyX6eWZccBt+OZQt7g5n02iI0ejxtxds3qhdsAPkG/gtyNobxeXVxOY27k8WwZ8zSvkNr3vZxKVS7b9jeO2STrIlGbVkekas8oUah5+FNHiCmLoDr6hjJri7sPgzK0jOPb9oP0ERVeYLDCJt0ylSHsOwQsLdn9z8kKjAIkRBBPUuDK1AiQhqgL0ZwwlOOrZVvpvNy71+iyaBEWfr2l6BlRQxowJK7kZKNB/JqJYPvA7Mlo/ZyLEhcQXo0ku9NnFcAFvyvry/3UQiTx3IrLiXtN2AKgpAzM29Cv9/ED4jPqvSIl/dFh1I0l/G5Wli5R2Fvxhthaa1N8o4joF8x2gf2ysraTgWbf3mlWroZxrfXWA8EkfrxUCeUcMsDvfkxRMzNPOEK2VXN1iixd3oyFo/570SFp0eEpBJIxD7jYDOgFNCarZFF7oIIqZwyCrFwDLS1Lefr9SoDuqHYAmHwklSbyk5sG4ETy0dPa7XVoLPlIytALqyLsGvjnvEtDWNrAgku0KL8cutohM0+PXioUknmXQY/8gYgOoApRwUSdqHEpNpFQy4Bts4fseeOenLBBWYRzDOYJfilXnzviPCOqhAZyLERoR+arRIPx9SydUv/WrQq0ZrReniU9nFfRRhuDD8wS2tLtLybEQ3LCQgKsv2uxEFGPWah4QXBAy4xSHVtXi45sPNMoRqIGJ1nd0A1QhJzx5CMsHs1NsUk3NC2u/kzKwKXG0wxULRCkAGHjmnQrJ64eYVPbPXnoIqj/skur5FAMkVQZOgFG8deGGuYqVNwrpySTT0VaHIK7AIY5rY4keaU1WQVW5wyLYcCtm0EdzERbvl/rUhlG8U6ifQW/pTQMYSBshaRjTjNs14uS+xB2GuxkkAn0RWErPs+TgFZxAhEkrH4ClGsR69c/1Ey5sOH012WTIWVYF4xhqCGxfwOblpIGzQ8NVDD1Dv36
 xeeVLqEv
 R5aZZyrAQ0SjhnOnuCpUpDztWZBFIQMP0A9+pfOVK6znyy7xKMklVY12EsQmOKEqli4czT7K2dXPEc/KH/AEtXET53OJ3pN/sVkMH4MkkDD6lgGQ8donKZEqdvp6/SsZzjgncW0JSK8xRyzZE191E/esk3CbElkOfD+AEPQgN6dbmktf6NE4XzpExvlyVSOGbx9ITOPrCEO5qSqaaYQ+dwzzgXlBJKG/gXlefozDU9IvNztc5bXeifY0diHjCLN6Eoru70m6i0E1vithxoJgPWinsG1izG/IX8Bt9lSzaqxjytMefNLqLGbY1KVnPRcFmWSgXupS20eHxDf1sOGB4SP+70o62xfQiNddyuuGMB2uueMe6t9P5iyr4OYqAennoEIVpMlYJAmBXcO0Z5CwxHvUzuHlGnULWHyrNzKmLm1oEiJutrJ1kwYlwCkTowRil2p6r3pb4WTLfuJ8beJ14gJuZfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 3:52=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/11/26 01:47, Suren Baghdasaryan wrote:
> > When per-vma locks were behind a config option, a number of helper
> > functions were needed to simplify the locking code. Now that these
> > locks are universally available, we can do a little cleanup.
> > Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
> > query_vma_teardown() helpers.
> >
> > No functional change intended.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Acked-by: Usama Arif <usama.arif@linux.dev>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
>
> I think you CCed me only on this mail correctly (the other ones went to m=
y old
> RH address, I thought that one would bounce)

Oh, man! I used an old list of recipients :/
Should I resend to avoid bounces? So far I haven't seen any bounces
even from the previous version which also used the RH address.

>
> --
> Cheers,
>
> David

