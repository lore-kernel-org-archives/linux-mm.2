Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 493F2CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67EC86B00A3; Tue,  2 Jun 2026 04:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F826B00A4; Tue,  2 Jun 2026 04:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545CC6B00AC; Tue,  2 Jun 2026 04:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4652A6B00A3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:38:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E54FF1C0EDB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:38:56 +0000 (UTC)
X-FDA: 84834322272.07.4A243F4
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0A72F20006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:38:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KM4Ieo/O";
	spf=pass (imf03.hostedemail.com: domain of error27@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780389535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlfk7g9yiLl9nEiaUzdoEKdI4vGE8q96ghOVqk0/wu8=;
	b=Tiu15GATfHzuhohZFkSswrE591nKExozr614uKcZ73vu/ZRIlb2IvbIOO6dY5/v9QiPx//
	A+PyixPcDWme2VZr/AVg9CNKi+Iqfs9A4nTgzoRp/2woRnF+5J9fzPH/D0AzYGYySGG+IM
	mPvPmD8ElticITrLgaLCjhXvm9dnb4E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780389535;
	b=OlyBPlkTz4jva2Www7yN6uWtk39GWawbd1Y0Qe7mfcvHX62lNIwi0Qv+3w50Prh8d1BDuZ
	cy6DiSQbw/QSo6llhfS2CTpmcuTD/nKgiJ/UpivHH3Z5zcp0IrD3RWJqYQA8SGbn3c9ih3
	vU4sm+lMPct346hL52nlAbNYCJsifwc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KM4Ieo/O";
	spf=pass (imf03.hostedemail.com: domain of error27@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-68ae265815aso8673385a12.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 01:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780389533; x=1780994333; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mlfk7g9yiLl9nEiaUzdoEKdI4vGE8q96ghOVqk0/wu8=;
        b=KM4Ieo/OKj0rgJPikdONJ2UiWKZkd9tGxMwonsj/Mg1u7ZPQVCwN4VlkAL+DgfL8F2
         /DfmhZNjNe4rIdKYvfFHgJfGb3wC1hz/mxJMirZ+zXlCMveitb5O1lRa8fn832uOT2bM
         CY4qeWbSnA7P++VyVVHXQMDtIJhYkM9y0vyyTW6Tl+pb8tkxU8yGdpI42JLPj47pWWng
         quBQ5kFvpJyC5QIyJcSdxeGADf/0v00RVI+RhvP1227u3ztvdTvEB8fY61OALfyp+XWy
         9oUlGCKa6fx/CfewtNsBDtJj36oGWX3KyU7DCYqPD6MLDOlTZNfeqfNLq0KY2vXMazOc
         Iwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780389533; x=1780994333;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mlfk7g9yiLl9nEiaUzdoEKdI4vGE8q96ghOVqk0/wu8=;
        b=Q3tLx08ayTvpbmTrSO+e9u614XiMAgsW4Nptp8P4TJEZ7shsHqiL0LAvTjdHTv8lqa
         iCs0/qF3ErLpQik1khrp2M2k80p/POWMDxpk7FwChAu8BJ7+b8LNkAEO9id3XR5DNs8T
         S+swz050HVaL38342Cb6qMCjEAkE2UhjUwyUPEzyIjNtWSLfXw+SG4Lc6aWn/w+C7T8v
         ckavrUS1guE9h4zqOMY4SPdYBkoYVpcal7RrAu8D9o9E4cZ+2tkYYPVQKAr4JRSdq2Ib
         C+nO359eIjij8Jc7aMcfd1O2lWp7U2b61q4tL980EIVSJfTDW3f9CBRiWtodC4FF+mY1
         YuHw==
X-Gm-Message-State: AOJu0YyrLYdS9ClNlugHMId+g3OSURVcKRzalsUPvd0+3J9VET5KT7TC
	09zHnCgae4COEcLSOa+zrgkOhk6+617rgFx8XOId/2ehjAnkSLjvOg0B
X-Gm-Gg: Acq92OG9pV++X9u3pxRw0x1eZ+8NyYLQt467gin1DE79Fzui+hc+bhZDOpdnhOUMRFd
	IXTTTcomMSFxrh1vJ9fHe9maiJ+cEIDqgw1cUSgTCMVQJuvT4onrtXR+oHWynpnxF6MkNSi4aPN
	k3M+ABLOmgnZ3y12GdsYDmXaThGXVsBm4QZi4jlb8AcwuSX3RbP5sKp12PLPgtJ12xv7y8XcHBB
	uwZBOz4sczOp8C7978yC9Ex4Pns+Qc+ZkjqaiC3Z+kDCwdkWBhz1KCsOtwL8E+sW3G/hntK0OAQ
	o7tjrI4OJbwnpvV/QEX2V3UsINor7sXf993guxlx+T2eImn1F5itXT9drP9YNIIdjdQ8VDU2EZO
	FSmt41O+2EON05kYTAAcTwTXR8q8NeQySx2MZ/O2C4IVSKmn3ufgFrAQWgttWPs9R74uXyZsN5v
	9tmwoGE7hsbbHYp2Fmk70i1NPLqG4KQQ==
X-Received: by 2002:a05:6402:321a:b0:683:75ec:c17c with SMTP id 4fb4d7f45d1cf-68c8b1eddcfmr7134682a12.10.1780389533133;
        Tue, 02 Jun 2026 01:38:53 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68ceb7ba814sm3140582a12.13.2026.06.02.01.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 01:38:52 -0700 (PDT)
Date: Tue, 2 Jun 2026 11:38:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: =?utf-8?B?a2Fzb25nKOWui+aBuuedvyk=?= <kasong@tencent.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: =?utf-8?B?5Zue5aSN77yaW0ludGVybmV0XVti?=
 =?utf-8?Q?ug_report=5D_mm=2C_swap=3A_ad?= =?utf-8?Q?d?= support for stable
 large allocation in swap cache directly
Message-ID: <ah6WmXpArORmRcbd@stanley.mountain>
References: <tencent_563412614416DBC00F511C21@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_563412614416DBC00F511C21@qq.com>
X-Rspamd-Queue-Id: 0A72F20006
X-Rspam-User: 
X-Stat-Signature: td8npk5o9ye15oy8irfifdjrs4j7qj94
X-Rspamd-Server: rspam08
X-HE-Tag: 1780389534-560233
X-HE-Meta: U2FsdGVkX19amtREPcu0OIrqFmZQCE4aGxjJ75d6I60XDFaWNvDGehreeA6XGKlIVyg7JNlLxjJQQr3ge2oUDrRiPy4wdmuvQ2P4oVZhl23rvvS/mTgWjz3XMW3OqTlGRtxzsv2P3QjWZ8lwDx3I4cu0tfUa6WqbSQhqp0fMHUea8DQeKtFDGK648n7ds4L096xB0YGs8ZlCN9hQyFfpT9ZvWX2woPESXfrc4Y6xsiso7n1kPDowjL/cwESFi7e10xhtzTd1d+TXGe82KSWPF97YRNiHkleJUj/YkO6c9EHdzVQpaMxyA5QujxemMo4bhvLUyo3n0lot7wh8OtSNSlfRtaT65Gycb278Pb3WQXu9J4WqVnTZxOIynqUwCW+v/TiJuoSF+94iaiRjXW4HXqLjWAY7EWoRAISMt7MZzrPUUN5CIWDny2B+TjtDPjwRPMYUG87Qr/ICuWXg6+Wpi6lRyOV+N/DrpTX1KRas6iuSG4GJjLTq1KVfFbN6/GTtrVMk2bKo/5gwP6yxNKitH8waMmydZucft2GPqIMiblkF0+HZdjNfZluSSCh7PUlR07WR5LwfkaFRtqU3twNjVCoFS7baykMlpAJ8+LFw4jSdd0ozkwyyKBiGBkCKVwhh6kkUU+utwms3iB7koBj7qnSVqVRpJ2FyUYTorirfGLuaFXo7cOA9yTXUN3xLxHOc6iK9BuL0Kyi/vk/G8PbPBBTIytMYnT+pj+GpjKRQXqckXVwrb+4om4XqOsWUld0SEjuRMSqmqC80a93bDJLG5MN63/pIi0Ss5eVTs+HsUnNToe/77IxNhzFA9Kv8QySGTMzOJTset7Fov246Tac+9xL+1xngJUi0RjdMJllGRhHTNGwEQWG/MLDFg5E/G2rvJ29qONR13vU+sTrwrBiflIxyHq+CwSeMz/CQj6deoAaQCs9dNmYVuTdGvA/ZKDOi3/z5px+qfrXv+ghvAbC
 01VvvrII
 Em9EzlcItyjg/xaqOzkcbm4in/F09df7C0Fk/B3z+np4+AvLkhLQpR6AMt/TF7R7ZStSnYBhpkS/gFLzKEDCPdp55r9fzdaA721xH3XmlxFZpfyG5VdSfV2NjucbQ9tL6+Tgrs6b9RYz0Ar3WHJrSSCHMPyoH//86Heqm5jjQ3gwdv0KsqJlGXfnSwsEezNBSF0qM4adF9D+EDvcZ2Qc1YQs8kSubRVm1yEiYze/Z2hSPMLubMIXaXzq+M+0z5j85Z9Xa3VOnIM1yNhjnvjy+agC3nJFuha0mFkib8WVvrxuWsH5V04q9ej0nmrl4nOp01IdOVcNvmf+BNOhvOj88bFiV93MMRD/ZF+YAPimUs+38q/ZweDXgdOWYZwd2pB+iLdcvCZjuTrAYyNmI1X3QzwMo4X+BBE746Wezmao6bKSFSItT/tJ6U45vCFMHtVeT2s3LYc0eRo1ZYP9FYDxb/YHxm05DEoFLUvoOvz4nDfhlGXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 04:21:40PM +0800, kasong(宋恺睿) wrote:
> Hello Dan
> 
> 
> Currently, no caller in kernel will pass NULL mpol with NULL vmf with CONFIG_NUMA. Do do_swap_page always have vmf set, and shmem always have either vmf or mpol set (unless !CONFIG_NUMA).
> 
> 
> I used to have a WARN_ON for this but some AI reviewers complained that the WARN_ON is redundant so I removed it. I can add that back later just to be safer, I will add a Reported-by for you. Is that OK?
> 

Nah, don't worry.  If it's a non-NUMA thing then that makes sense.

I was hoping we could just remove the !vmf part fo the check.

regards,
dan carpenter


