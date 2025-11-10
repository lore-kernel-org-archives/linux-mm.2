Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EB19CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEF428E0006; Mon, 10 Nov 2025 05:58:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9FE38E0002; Mon, 10 Nov 2025 05:58:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8EE88E0006; Mon, 10 Nov 2025 05:58:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4B7D8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:58:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57100C0D3B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:58:24 +0000 (UTC)
X-FDA: 84094398528.02.82A07AB
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 516C3160004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:58:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=icvdPu+9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of gorcunov@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=gorcunov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762772302; a=rsa-sha256;
	cv=none;
	b=XMxk33EmApGAfIA2EjdacOg3jUEZm4IA8rL5GyAbYOlsiuPFdxyXmX3B68LO5LeDHz/lFN
	YSdeFB0Og5PfNcGYHLvXhLv3Zn16QESBY2xCWa9hhTJAdbXuwscWITHXoiFWzvYJarusXE
	OAf9zlLKBzqNmCRBey3nNfENTd3XGTA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=icvdPu+9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of gorcunov@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=gorcunov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762772302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cQtUBYgJJUDzd/kGspKY/MZmhkbZxSeoEQPwDEqgRs=;
	b=VB9RcqJY6c2mWmhy7SAJj+m9y/McQyeGdDkE34vyPtzhrTvY8a00zPpOP9IIZdwQnlVZ5v
	Q2BW6H/lHiJdz7jk538MIApJ/R3rsNhEXkhRvOsCENl2dO9fzXr51ONogfkIK7huzNn2ak
	nxpTF5jOdMROQZVIPjyDr+DHxPVS2n0=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-37a56a475e8so29838641fa.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 02:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762772300; x=1763377100; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cQtUBYgJJUDzd/kGspKY/MZmhkbZxSeoEQPwDEqgRs=;
        b=icvdPu+9TIIY5YTZZC7FwoDhpMWxIkL4KSbI4BtIUAW72hFGYRNykNIrlP05EWBn6Y
         wwmRt793fuVXG65QyswZD8KYF6GtmoBFNjw/cxfW7q/ryPxxsHHV+EDt0SKStNRqgWul
         /m/cOjdxmaI/T22pqYf4UNtgoCBHajzKtYVuxpbTvxYlSM/UOLLCsyp9iadnU373NOC1
         hhVWwxAoYmKQU9DHvAK52l9MaLWuiQR7bOC5WNGLp8CYmeIW1FmOJLU2wZUArbXWZ0N3
         r3UEs1abzKFy3LoiAvdfXsRA3bOhe6ixEbrbzsz/2hQrGX5wTBrI0yAi1D2OV7NhUylO
         nO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762772300; x=1763377100;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5cQtUBYgJJUDzd/kGspKY/MZmhkbZxSeoEQPwDEqgRs=;
        b=maPpDNNWRPZ3Jj1t4+dTzXMWLGUqbHqcAcqAVvW24oQDD/AhfXknhWC+C6vAOGi4En
         220Rm8UKqxaaSb/JT4etB3ol3m3G/hrpqEhIB7TSnOcEINMu74m6qUKPVDPLozfIgJSJ
         PQ9Q0Ss3+MfhFzrrcZ8YjR5NvhMwm/rD+4AnS+pGDbTsSVTfqhkzPPG5yKTxY5BeGfjX
         zktgwmEVMu03L/yK4D349iEqqZbSpgS+qV8aodXGig7hibP2cm4NlEbmNTF66z2qGPlP
         iDa2RhNzY7rWsQ46MdhWUAfyhXzZ87EmK9s60/Lautk0yM5pehww6Q65mE1o47GPmtWw
         J1/Q==
X-Forwarded-Encrypted: i=1; AJvYcCW1Q3xATuACUOM6ySa8vrfL9yxSWcIlWdKW8qqhQ/GemjZiV4/qizNiWxgYmns76VBauc74cnLVJg==@kvack.org
X-Gm-Message-State: AOJu0Yz7pYIKq9B+ofJ/TTQBLarMdQaZ0/erUmp/48TbTPyxjTTF1fYA
	sk+5/wHp0Ntgapn+aoW6hOvrFFJKwLV62x6E0WYQlultYMayH7+YAC0gNhD04uQJ
X-Gm-Gg: ASbGncvj9E0Ju4Sx64dfyG2sAa3sM3VnKoowJg2G+dOhYikTpuguJ4yuZhUrknKWQ2/
	lTSV5tiw2viNxuu1oxgEuIAN8GoHi2uT0bqrjkQlczUFmlbcZX1dHU25ddgApz0IYVShVOFqqPa
	FNWgKZDXdyFBmapKTXUzgkYpN44uJr2hAK5jeEqAx5U5J6TuF1PXsNbqTquGHomJvcnv+4vxB+b
	IN7raSE0P21gx99VEA3F7z5y2oMpiboxYo31XSbso+1wuZq8lvVZKycr9pkV/Mc7dZR09tAtjU7
	CttoeGhLxlgP9izAXg5e7IqepvBksKRv4czzwUvpWVh9SgpdiYIEREpF+bKNaZPa70Ufv49B1P4
	nzxPayrawr3dVzZFWgUZ8FXthhPXcBLCpUv79t57fcXSG7kOAB+EsMFt+4Q6IQg1bTPuzdPn1Tg
	TYIyTx8/skObUE
X-Google-Smtp-Source: AGHT+IF7uc05YKR1RuoI0CoWlX07D9z81TzLgbg2o88xiS2GWX+oFbp3ZEM1dvWDPFPIbk1p56pL9Q==
X-Received: by 2002:a2e:7206:0:b0:378:df5b:fbac with SMTP id 38308e7fff4ca-37a7b30c374mr15069891fa.38.1762772299942;
        Mon, 10 Nov 2025 02:58:19 -0800 (PST)
Received: from grain.localdomain ([5.18.255.97])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37a5f0ee40csm34451431fa.43.2025.11.10.02.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 02:58:19 -0800 (PST)
Received: by grain.localdomain (Postfix, from userid 1000)
	id 691DA5A0033; Mon, 10 Nov 2025 13:58:18 +0300 (MSK)
Date: Mon, 10 Nov 2025 13:58:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] exec: don't wait for zombie threads with
 cred_guard_mutex held
Message-ID: <aRHFSrTxYSOkFic7@grain>
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <aRDL3HOB21pMVMWC@redhat.com>
 <aRDMNWx-69fL_gf-@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRDMNWx-69fL_gf-@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 516C3160004
X-Stat-Signature: dg4y7aik13q6suwr38kh3p78xm58aoxw
X-HE-Tag: 1762772302-894045
X-HE-Meta: U2FsdGVkX19qFlhaa+Jq4qVVX2VI4EOjs9Zt1bWMQNqbdFSl/On696ZHB0XKpvORqYvuhYyYvKVC8CRNRN8GSOVVHYSOFjJ+x1NIokcmAOwi/EgfuuiEtXveXcZiZlO2ersgye5gvaNJlA2RMtnOafztxeySe4RjIXTCfS6Vzyh3KCmm1DMAFqSfWG2taaHOREHZNxazHLtBIL5+Hr85scagyHxVt6+7VTiGwpUO6WYB9m/s5OXONcmZ718ZinjJfsniBEVW3OiQuWdLAnIGtfTTCuoCh2Vaxm9uQBvMAkMhmsAbvRcSdSVC0BOQtrrU2lzqiRUvEvbqBEWiuvSVZn+EFLJuDSV+voofCBL+ZpFNxfrCTfljn2hMrDLsXob/dS5CIajZYGR0gl80xcycE31FyPjhlAry4IflDbrLOEXfVHwkAFLHZmDGwPj0Xxr/rO6UL4elbVqccubyAIm9p9/Vd3t/hn85hGf3VQE4Ung5lyhUsxuiduIu1HqgrgnIEY8gblJE9nXdVYBakcaxdbAueFDIXWfs0dnX/fNge0mjGe/6mDTvs5+YnVIQubMx0kHwtjwjxIqbTyjrWyYcHsk1b1enNvAqcwj3fljZ7Wmv/AKZE4LqSzknb1Zy1mw0nPqO0DBRTeCxutS4ekSTQRVhCxmJyRDJhdCTHqjybQNNDWgneAzUnFUAJKI2bUr0YU/kIxbVDp93HSYsBrpQzJRYg3/yCVCqIRWT+tHsiwt8GbW3n/2v56ATEyxgnG1jxUdvk9gOJ+5F4ZmT2lp14LL5cRKfFpkV/1sblHI12uSa/OdfRh4DmavyhuBQzfMBZV2JWaBtNJ1gJ/UMQ7LmV9ec20sCmaQec3kg64M0cphahzPmozuGQLarCAHS6WP2i1oQ/JrHMmo7jNUSIxvP63Ca4Cxc2+vh8yvF1lZaTTvhfh9lxjsgCIhKBkp0yz9hcFMSShmrhWn7RwjSIta
 Wbckp8+g
 kkhCPrGjReIN3VG/j5hgvMx0Tj47WlV0J1a3s0K86UCvPDEeH0LJ1eYadwY/9WWgTvwI2WwbwvJ73jSxoOWsKXZLWm1XhENgvCC9aUPxm02dreXHhaQ2SoT8QWr48gDsolhU+29lXnKqrcSLHyuIZUtt/dIa8FVs8bICH+kBZsazGEoPKZXqgJn4cJJ+IOrJFwd4qDE3x6sDpcy2/okTC+Btu44rcgF1vHWLpY+BBpth3I+yXDRQPDnt0ChRYy9TsbBj2yGbKSDTLUYwfAJ+093jtJ+e3G5vRnFpLXOlMtnWG9FDc2FojvsvHdMxs+20EXIyXMOqdvKYRcNxWyIjp1BcMlu6cbIDK0u3r/LiD/WqXXzHrg6bnXSzVEh7pPXl8MQ/XGgFNQh18Owyu5oWsBqBRycjlLQHekXubp8g7AGyqBFwbmPzgVlesdWtPhX2AB4Vd0jB0Ez/J+S7/psRajlSgHJUTtZv8NxGqqSmX6LsgNKYxTq6lThsRRtrVciaN+MNUP4EUnQpGsGacF+3diSYIJu4JzvboAi60JSFkXNXzIuSzzHHjNRW9jGAXHggeB2ZI+63dIY2VBRwdcpVFx+I91+C4b/hUOJ+z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 09, 2025 at 06:15:33PM +0100, Oleg Nesterov wrote:
..
> static int kill_sub_threads(struct task_struct *tsk)
> {
>  	struct signal_struct *sig = tsk->signal;
> 	int err = -EINTR;
> 
> 	read_lock(&tasklist_lock);
> 	spin_lock_irq(&tsk->sighand->siglock);
> 	if (!((sig->flags & SIGNAL_GROUP_EXIT) || sig->group_exec_task)) {
> 		sig->group_exec_task = tsk;
> 		sig->notify_count = -zap_other_threads(tsk);

Hi Oleg! I somehow manage to miss a moment -- why negative result here?

> 		err = 0;
> 	}
> 	spin_unlock_irq(&tsk->sighand->siglock);
> 	read_unlock(&tasklist_lock);
> 
> 	return err;
> }

p.s. i've dropped long CC but left ML intact)

	Cyrill

