Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E17CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 21:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923DB8E0008; Mon, 22 Sep 2025 17:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7CE8E0001; Mon, 22 Sep 2025 17:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80DDB8E0008; Mon, 22 Sep 2025 17:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7BF8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:55:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19AF8B7736
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:55:56 +0000 (UTC)
X-FDA: 83918244312.24.6760091
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id 36B7840006
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:55:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JiGcOluK;
	spf=pass (imf11.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758578154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTHCUySsAgP6wxXlzXUMsb5ERn8ZmdP+HwnZhOMU5OA=;
	b=q5EMPkd8XVrrUShKD7s88ld0/NS51EwWrik/i7dqZ1C2jC/dPN0eZAUy/o5+7XDGZidHYg
	nQHbCuG16DvqDv4s5d5l5fkpUddiQteoGsoHTXpHaLiTUg3ZIYLgtb3lceLvpA2N+i4uZi
	5rKp+pGkENHhYTroTxkAo77nHPqtXio=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JiGcOluK;
	spf=pass (imf11.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758578154; a=rsa-sha256;
	cv=none;
	b=Q3fOhB2cnAsNOFD+cBkTB1FN9xlCK8YRqPV4+VO46epV4dqh+L91PqHmbiESWlrxKB6R9a
	Re8sZCe7HhkygwqLXMfrK/yXSSVuRDZ6wks8Gobmmj1QoTWb7AQPuDgRwZe7k9Qu1DMvAb
	cnSXp36hcpcIaVdWDNLJR+jrUqa9r+E=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-574d36a8c11so1436590137.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758578153; x=1759182953; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kTHCUySsAgP6wxXlzXUMsb5ERn8ZmdP+HwnZhOMU5OA=;
        b=JiGcOluKYQjf3GrF+VNVKQIceKFexLF1MNSnk8haL2ZXxnNcnWg+eZVcJ2Edu+ML4Y
         3AuXa/C6syu28FIVJdEh9Bpt9f9wGEgvIW2pGHkuxnCnXUY0CBZKfVWWWh7egy2KidGO
         GPwOOn5SHd+/nbACQTaqQIb7R98qlZJD5C/5izkgv9QVusbtRDk5OiSMruc6txU9yhZd
         KALAgTwdWiW2LH6ZyYkbdj1J291NIAuFvHtjS/6fWnA5gCXOzHPkQaMF5t6JNzst5+eH
         dyFScwGss8J4ZlMKSwbUcOgOccOvc4FyNccgzvSp4aSl10l4lw1Nbk13FDCB8+zh4NE1
         5biQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758578153; x=1759182953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kTHCUySsAgP6wxXlzXUMsb5ERn8ZmdP+HwnZhOMU5OA=;
        b=NB4SCASX6hjrEaNIwm6UDO0m33DinU0QjvULi1RhrD6HCxDkT237sYHWPSQl2rDGm4
         9RS5wOYCXAAOCrguTPXLOHjLuchFgs909G9PFv1YSxNdEIUOjTR+UptxmOU/jTsNwqw5
         D3WdojQiNKQtMSThKRNNDljcrRdie4U5k6Vqu9qBWq3P1sbzaUHBlsABdT0hTxqApYaO
         0pC//Iupnf/S/wUs/nntrvRW32e1arwHbA51n+PF5PFLOaFK8YTPC1m5L56DjZWS8iQP
         6s7c4vjl6qFocE9PzjEWetlUtBBhY5jn+uVSclNFyQLzXkFyoJTgsBtD1bwuhhyjeP8U
         03xg==
X-Forwarded-Encrypted: i=1; AJvYcCXWqHpQ00tF8gVuZne5FUNWKglHHjMAT6dFD/vHqSj5YuoHyisgxftu1ZWqB6AFcWI8bsn/mtznNw==@kvack.org
X-Gm-Message-State: AOJu0Yw674R8dVFvpoUZXEvj3NdQQ94exV2Z66A9ce/s5MscuuHMAmJU
	Ad54ZMMSZBAx9qwzfBWXJwvR5KMT5jGWriKwg2Ub8u5EXR+vlN2Bk9GuyxfXBNp/OYbHXF/gkc4
	p0NmYuHOawS5PNsmfErVDfCouUoCqV/8JIg==
X-Gm-Gg: ASbGncsrgvhCv+zRTj34YyEFkPwRK2S1jZHloaKCYebfBCoDGznXiUs/aNQz5i3irDO
	BhwmKxIZ46z6MQ4xHp7g+SGrPn7arAnwfKfuyL5VbecH6SgdIsxbHrzXNAlcjVDio99SJSTbtmw
	3q8T2jP5U5apFxzJ+2GUzcs3UB+kpDTCtqG9Go4sRPeG+n1YjpYbWcjUhTEN6F15U+ZbQYzCBcm
	NWGlZEjCJ59W0+3m9SITvJmmnckFKuuSef4vyE=
X-Google-Smtp-Source: AGHT+IHOz+8/11z3CO49ka5L80yW5m+VRpGco9UMZ1EjvSRe6ZYReFt5lxYnV62pJwrR5DLMt1AZon5pYHmXn3KDwhk=
X-Received: by 2002:a05:6102:f98:b0:521:ec86:77d3 with SMTP id
 ada2fe7eead31-5a582330312mr174933137.21.1758578153087; Mon, 22 Sep 2025
 14:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com> <20250921014721.7323-1-hdanton@sina.com>
In-Reply-To: <20250921014721.7323-1-hdanton@sina.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon, 22 Sep 2025 14:55:41 -0700
X-Gm-Features: AS18NWDwXZgd8togHkyR5VuYzyj7hcNQKVG0Sjq-VJyhnlscuDpAe5Af9RYNnFo
Message-ID: <CAM_iQpXMjFs4LmpRVNqxeBnFp4KxEfgi9cB_Jwuy7VgOSqTfsQ@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Hillf Danton <hdanton@sina.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	multikernel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 36B7840006
X-Stat-Signature: 3j4qh6t6w4jq4kfkhnb1agc1feg61y1p
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758578154-853669
X-HE-Meta: U2FsdGVkX19jccfMHCBFDv6nu6EjARswvdA/WN6ubNr++GaalB0vo7z/hO6Zi0HQlzc+aY3RhMMl7OTzzdcqUr+Eg78srOj/xhnQIFNL89QQG2/tmsVptyrSewc+6nXIQAPk75Z9Ag0o5E5Tg/m+vdbhKPOxsfdxGasH2tEUluNufrp+4935gmJSEFIm7u3YVAE4hVCHRC/2lYSssEYb9UpN4/3mvXFQR6mfj0qPfhzTUsIjGX+LdGu7vxeqVhoFw9fD1g8423dWn+R1qbxa2V70rXS9oe0vs8RoP350CJqfHenjnQHd4LWZtJLE74PAwvDw8FM/o0CT0DHMlNAY5Lm7juhfo+P5j0w3OCyul8Fc6zWDmAuj0wnxbfQK1MyPQq3LiFTe/qg9fsoo6nEmKceQs/6zwEv9iigWpxnhcSd0TQpg4Jo35nVAnoCMH6yECkE/DEuo1E36L0eBDyEnJRSxUBntSy8Yb/cUUkXutDFhIWCV6NdJD5KlEsweXUsD1aAwTBAORA3zjn0t20XBQPf1HgIZyIzSp3gLe4faqrypnMbGE71knwjFQ4eGe61/uyRmYhZj7crLhm14hMrenM3F7aBN2LKdl7AZvDiGNCScRPLJ9x0C2E1FNpvEyHnc/kVyy+fy580Fr6dMOzpMITkvqqVerzE/kspVNdqPUAWThTsmbbmBkx+YNLVYRpzbJPV/qt+hPkpvKaHZKplwGIw2AiShhaCVhsgrElCJiSPEE60MFHl4zjJ9aSadb4EbPIYK+BW0AjMlBbyFsCuvofWpWWJg4SYXIe6TBQrQ5G2dYrUPL3dxBiFLtWxdSt3SfqPEI/1wV0QKxIr8pK/8esYNTjWOmTa2peKsN8fKRVItflS+hKivsChLdwvhdVcmgBD1itRvtQBOrbb8RdlgP9lqGBCBdmknmhTrks0dqAFkRvjlNL1AfoUXqTw4ytwgm5tW56atnpze1yINB9t
 csLFOzAn
 qWmAFCRjkvFRNr2crN7EOElSjvCS3d2si4xe+/gpwnZVdfYs5JZGR/QqLFkUr2q40JGOLLG79N/4yeXYiCh0jxCY8EhSPd9sGSW/WGSjDQqtGg4euSulylO2PmJrrpmYqs0eXDtGVGEjdYqL+Npftlo16buyLoUGflb7l8drZ07hVz4leXkparXgcXUwTPpa5ktcLmZGWveI3Argo5xVbaVAZJoB8vk5oK9zTXdJ+EaPRz5zBHFcpRHemIJjo7+2qhp3YwHSks79sVM7oF4B4TSk/199nkIH6wRM8FCQyotvK7Sd7Q5CU8TprrdKfvegoPG3aeCyz3COJh3zakxPIx89v/rbvkRDdlNI2sHf0o+mhVCJ1hgXBASmXfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 6:47=E2=80=AFPM Hillf Danton <hdanton@sina.com> wro=
te:
>
> On Thu, 18 Sep 2025 15:25:59 -0700 Cong Wang wrote:
> > This patch series introduces multikernel architecture support, enabling
> > multiple independent kernel instances to coexist and communicate on a
> > single physical machine. Each kernel instance can run on dedicated CPU
> > cores while sharing the underlying hardware resources.
> >
> > The multikernel architecture provides several key benefits:
> > - Improved fault isolation between different workloads
> > - Enhanced security through kernel-level separation
> > - Better resource utilization than traditional VM (KVM, Xen etc.)
> > - Potential zero-down kernel update with KHO (Kernel Hand Over)
> >
> Could you illustrate a couple of use cases to help understand your idea?

Sure, below are a few use cases on my mind:

1) With sufficient hardware resources: each kernel gets isolated resources
with real bare metal performance. This applies to all VM/container use case=
s
today, just with pure better performance: no virtualization, no noisy neigh=
bor.

More importantly, they can co-exist. In theory, you can run a multiernel wi=
th
a VM inside and with a container inside the VM.

2) Active-backup kernel for mission-critical tasks: after the primary kerne=
l
crashes, a backup kernel in parallel immediately takes over without interru=
pting
the user-space task.

Dual-kernel systems are very common for automotives today.

3) Getting rid of the OS to reduce the attack surface. We could pack everyt=
hing
properly in an initramfs and run it directly without bothering a full
OS. This is
similar to what unikernels or macro VM's do today.

4) Machine learning in the kernel. Machine learning is too specific to
workloads,
for instance, mixing real-time scheduling and non-RT can be challenging for
ML to tune the CPU scheduler, which is an essential multi-goal learning.

5) Per-application specialized kernel: For example, running a RT kernel
and non-RT kernel in parallel. Memory footprint can also be reduced by
reducing the 5-level paging tables when necessary.

I hope this helps.

Regards,
Cong

