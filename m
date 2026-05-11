Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A6E9CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7757C6B00C0; Mon, 11 May 2026 09:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C2D6B00C1; Mon, 11 May 2026 09:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664EB6B00C2; Mon, 11 May 2026 09:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54B966B00C0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:44:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2381160116
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:44:12 +0000 (UTC)
X-FDA: 84755257944.28.0545401
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 100921C0010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:44:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=X4ipzESd;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778507051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdZp73JFANv1yjTZ6h8yU8Y68BeneeXC5aWjngszTTg=;
	b=b/sKQz0iISr3hkPrmZXxJ81CeX4YcfrTmYp9krwbhA4CUe3Jt6xzyEPlAG5yTBeY5TO6gr
	LS15vcOszKT+r9M2IYEEHzmF3C0g8u51Ss/9d19wbzQm6pMycb+4jOGXxGarqPZPCmvZR/
	uEVjZZhHd7nyoccIWN5UhZZK3wkyclU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778507051; a=rsa-sha256;
	cv=none;
	b=YUMMAC52QcvkCb+aQpdErq51ISe6eSVMeh3JH4ndiIK+aqCNg6h4gxQWyGJxwuYZ39BmaI
	LgUUNtzaYZ1Maq7pke+r/tEaBI1EFYGBRDjIDrc3PHsn4hb3RCFEDbRLGuQOSyKs6ydcoW
	mb7v/NDivel20OUcscl434b5YwHcK/4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=X4ipzESd;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7bf14e33f5bso36064277b3.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 06:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778507050; x=1779111850; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WdZp73JFANv1yjTZ6h8yU8Y68BeneeXC5aWjngszTTg=;
        b=X4ipzESd90yLVf4bqYrVnULfLL+Lh0lkESdmf9mEzV03xoEakBzhsREa3piU+7YUb9
         OyqofstaU+xkBdZ5nh9wNkTOa6BYn/05Z7DHhxg3O4n43q2Qdj5id+NVgRrP4cQCRi2j
         POV1aJCgIgLIbZl2EfttnOXunZOXnPm8V5olEOLZZ125hzj9oPEc1ljoi52w/Sk0Z3dA
         nJyURawf34vBEg36tvYOpPJWMiZtI5+jesZEgd1tu2fi9BZT3CeAMJYFdLAou+D1L0Tg
         wVbzUd9RspSu2n7KHtZNwh7DdERXajlUag5CFaQnRXxt7bMli/P69yP8GuH4oQy3cqL2
         TPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778507050; x=1779111850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdZp73JFANv1yjTZ6h8yU8Y68BeneeXC5aWjngszTTg=;
        b=MguZjKe69XuR7HqsH9VB8h6GF6mBnMTXo9a9qprcW6MjI0AKAqAh6yLl5XeuQzZ7rY
         5r85Cux/JqMDtOge4dCkEkq1eZNzpkvZ1Pk1R3SdsgFhLjsZ0PsDOiMWrX6tNKmGsa/x
         5YOH0i1dWsGoFnli5j1aYr5G3z7eEeAV4Y8a3mi++7668radeGWI/Ho6e8PCnrBZ6Hx8
         3CXuMZTa9UCNgferVprPO52jFDWSvdy1Cq6n8ijnSBlQpedtBuUyygRxrugxiDRhKpuQ
         Dt+9kl5Qo6oizfVLyeP/i0cRS+kaN1/5H90fSgPl101sTXS3o/TKB977+rCM6pF5sNkg
         ejiQ==
X-Forwarded-Encrypted: i=1; AFNElJ+rsWxYzikL7q5+5VkSqzOsk7vw7CNYhhSB/P2hN0ia/kAbFWlPmIsn7Xbqlg3wDjKqMa7sFBeS3A==@kvack.org
X-Gm-Message-State: AOJu0YyWceB9CekGE46FWoNLi706o58vITCAjC7OAioREoOWDz9Eankn
	3TI1iOhCDTJ1YHI+E/GKQqFthPzbWijxmoTolaj7B1jizHDHZvCP3yZEFULHHHUByV0=
X-Gm-Gg: Acq92OGC4Y8sP+lc5MCi8yhy7opBOgFML9R1kTpOc33SJB2pwu4bdKBUvBZPe67gmhA
	/ChiQaBGxLl0MFMLjmG59GoEsta4uN/aYuyEWn0+s+GtUP+YqlqYIUdd61A4PW7ZJvePLihSMyW
	b8fkU59Ld177o+BNEX5QlGi4d6UwpWePL1+GbafMNSbOOd+s944OpSspZZMZ6egx9SZt1LhSb1T
	j9ciyRABL1vTe6rdWHqMLiS6paJ78yHgAjMEBV+IkE9mNMxBSo8fWdAa7uhlWRuoS0Ha00MKE0R
	wOJtMQt+1yxIUooDztS9E4HdoklKK2CF+6i6uDO6vcviTxC6JrqqOfyshp2LnvZReAzFFuDQt8l
	BYlZB17xFtFlnQgi4kje5V2KjLxptHd3bfX7AgDDjB+VPk2uaHyPWLlL/EUqlaWBdgPwVnjclNN
	vbjh86YSQxUJAn2SBIzBMHcL8fWCWdiKop0C/hIUhOl5LJEUtqLIqb4LML/jrS1bmb2/rgmiLf/
	7aoOsF65ekKXevD/eMltrwakX81UAIKCoxq5te5hGA=
X-Received: by 2002:a05:690c:3482:b0:7ba:eefe:9f9c with SMTP id 00721157ae682-7bfb93b91bfmr134951057b3.23.1778507049874;
        Mon, 11 May 2026 06:44:09 -0700 (PDT)
Received: from google.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6686ead7sm150263157b3.39.2026.05.11.06.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 06:44:09 -0700 (PDT)
Date: Mon, 11 May 2026 09:44:08 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, rppt@kernel.org, 
	sourabhjain@linux.ibm.com, jbouron@amazon.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, bhe@redhat.com, linux-kernel@vger.kernel.org, 
	dan.carpenter@linaro.org, rafael.j.wysocki@intel.com, piliu@redhat.com, 
	kexec@lists.infradead.org, graf@amazon.com, changyuanl@google.com, 
	mario.limonciello@amd.com
Subject: Re: [PATCH v2 3/3] liveupdate: block outgoing session mutations
Message-ID: <agHcu9_eSolgNZFT@google.com>
References: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
 <20260506182039.2623553-8-pasha.tatashin@soleen.com>
 <2vxzv7cucint.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzv7cucint.fsf@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 100921C0010
X-Rspam-User: 
X-Stat-Signature: q7i6w6hc69ppgqdhs8dmgnyrdi3jj11n
X-HE-Tag: 1778507050-149180
X-HE-Meta: U2FsdGVkX19FDD6uMW+FoEuI/dPInKDeLfBF4kXJO+Xt/G2m/qpwTaXH4uyvsFdcOXdLX5d82dtMjSD2aNbCnyTND7JZrPbCDbbNQMcIsS3gydDPRZ/lQvCu5RysXY7p8uXCuo6hcASgfawWw2nvgrytbJyE8A6rdEZFtoCCkOjID8Pl0ywIdX4OXW2ly4m3cYaJHTddIDUcUA1RB6Uh8fHGCt3sXRo+FTUVa4FTijP/dWYmPPabFe4rTbRLKz1QCKAkPoiC2G5i8RAiUW8qybrSASS+7v9+W0l+qS1kAm/Ha1qNtSXd47waHYToqP1M8zYf5j9ypCvgqZje9wUeiqZv3Xqpuz9gzjqoU4Kyelmwnlt32rH6jR9LxgVvB6YTGwc4dkXV9lnmv/PJ6r9FdjQVIr8WfpXuNS1GyEg9x/Pn99c62+f+YHhMsNf2dQOc0TfP9Fwf7xZYYdmBBQoHGjotP1yOIrO4NcWExTIM118xRIfL+k4gDFBNxl5O6Spm5u+TNV4qYqLALI4oR524NZrHx5NmmXnsvBhrc7GLYDjxcTHiemZBcz+ZNfRLbsRDp+5zPiXOb/6rD9XaiQef8Um+EiEIn4xtYwqgts5PeJZwbOmSVTn9wrFpmcESTnFVdvghZuUDrLOREPoWZd7ukWca1yKE6k/PdBidqSL/zhksjRmhFzlko0+YxeO88yS61VJdU/eiuP1LDcnckahX1cEV+amBqrV80QltlPPN5Fh6gEQzkAHizcLt8uYn2o1NsZ/NokvhfGotRThmNsKw+zTphbNaNqqxCXzuvCv893bUclfz0sxd7zMzVaET3nDeCZ4s7PbrPV8/yMRwyrLflqgSnjBBEidv33o5KSKugQOwwbsDk6sHi/J56eMdfbBGVvuUJgLkaqs/q4Oxadm7x+czhNkyjlwkUTWr448f5Q3ej8sALhnRVKP+dmssVR5SVEMbxZKAyFgJ1k5Iyds
 E6eIfhN4
 3hR4j+opmL2YOQ8DjcLlxb5eknt2XBt9SFz1rfb6nDPLT8Che8SM7s4YT49ms9lT0jHYfuNMUxnYlMZdPvu6dg8wuxI0zXpcNRyCiiPjErd6p5Yb5vJEubp3nMiM6y0z+azeMT2a8KGJbWEDgYj39XsE1NwUD9icTdajDRXJGJNOSb6EYrZyPiDmdSsPDCBY7axoGSywwFQlezcCUObTB9Zy0ctNIkcEWlI6ONDI3jTJbsc1DV3uNydSiyW28uuDCITtFibZHuPGojjogbnuq2Ld0/ePsfVhpiCRrcKEhIeARSmjVWEx4PT4eGV4kBZXUvXfqeGLizxIs6K2GsQtt/QMIFWLWn5xu4Ni0ZFCwBzJiekA4vVHqP716MB3/ypvEaYuduweMuvxoSJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-11 13:03, Pratyush Yadav wrote:
> On Wed, May 06 2026, Pasha Tatashin wrote:
> 
> > During the reboot() syscall, user processes may still be running
> > concurrently and attempting to mutate sessions (e.g., adding files or
> > closing sessions). To prevent this, hold the session header's rwsem and
> > each session's mutex indefinitely on successful serialization.
> >
> > If serialization succeeds, these locks will never be released as the
> > system transitions to the new kernel, effectively blocking any
> > concurrent task attempting to modify or release a session. If
> > liveupdate_reboot() fails, the locks are released in the error path,
> > allowing normal operation to resume.
> >
> > Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
> > Reported-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> 
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Sashiko also provided a good comment about this patch: We run over 
MAX_LOCK_DEPTH limit with this patch. I am going to refactor to not take 
every session lock simultaneously during serialization.

> 
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

