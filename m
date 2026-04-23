Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4880EF589DA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6E26B0005; Thu, 23 Apr 2026 10:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278276B008A; Thu, 23 Apr 2026 10:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166D36B008C; Thu, 23 Apr 2026 10:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF7B76B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:04:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76E811B6F40
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:04:30 +0000 (UTC)
X-FDA: 84689990700.04.9179A8C
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 88AEB80008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:04:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cI0b91gs;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776953068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KWq8azbCSD7brpyXZ6QpBU16YtUoefjhmh1Zjdknw8=;
	b=eZWR4n++4hH2AnAUTsQgP+Um2Pt1I8CFYz5SxHJpzGBkPaZF3fOM6RceplrKN+/Lq9HIXq
	MrcDtwaR/8zTI5KNnoZZMH2yyWCimpkrfPEvwWkFzCUDgsB+l80ZS3DZEwoHKTcABtX0ma
	h1+8tv2VE9K8VSVTJbvQZWXr9ZwmgK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776953068; a=rsa-sha256;
	cv=none;
	b=ufx+cgrA2RXCnW4OPqvvnTP+zGdaS1u+qLM/WnIsFF5Hot5Os2EJOzMFbm5HFtIBAERKYS
	ulXWa+raYK8xIFaoYbJIiSMtyLuzhTd2WhmFPROcwQUPQpP63hnRSFOsOJW4UZZzfkRpFM
	TxuDYV9QhpTLApY9KOm/6+M492sO2hY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cI0b91gs;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso61951645e9.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776953067; x=1777557867; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3KWq8azbCSD7brpyXZ6QpBU16YtUoefjhmh1Zjdknw8=;
        b=cI0b91gsSS1xJS/OIY4naiC4upPEkzQVvToPb6CYWF2rnLLBE4BDMlu5Zyn3NlCrUl
         +ZpKnNwamG4lmF4J/zEQHnw9LT5m1pqqD/RX2v2NZ+MEO/N2aEow9xljEDghCJc5p1Ol
         Xuv333LVXgp648ih83XljruTprfbLmW9c1TlqTcVw/b8OHBKRdPtItbxJzPV/iRM5v1c
         mFKOsQnUMgVdZnVUF6ERzVVUQp/e8flcBf3rW0xxTkekD3cjyZfk/fjIbv3ULVfrz8yv
         MQA7v9kliXggNdz+1+o+yd8DKPwm36SHW3bHLKuoQ60d4JGe6dHrU/uPghzursUZblh3
         zALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776953067; x=1777557867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3KWq8azbCSD7brpyXZ6QpBU16YtUoefjhmh1Zjdknw8=;
        b=KHUeA2QDF5T4xtEMrvGSTqFotYp5j5VzYJm24HBCS8cDbGHblLR/zcD7L5dnu9xdEU
         96fk0UedIBCiia2tCBr6hqCLlpFUcAKp//77BRd1aDS+1Cg7vEmhN+LzUB8k1ppuNh3K
         klDdCbdXEObYjy9jVemJVjS2tXipjUPOa/0S2+0oVT7e0c/lGMIKr22+32szk0VTe3oK
         MN7yatSKrL9bOQBGxl8rHfif7u7c8+CDrNT+pGLbEX4PMysc3uDyEwiwjMz2j2VK6LCg
         wB0QZVIdewpWHHTJJPiB/yiQI9GeyFxJskHoa+a7ZeZ5dZaCw7GHDotqJN/hRPJNjKiV
         TvJw==
X-Forwarded-Encrypted: i=1; AFNElJ8IARoRW6pCLaDbhDxXKeKxzMBE006POUZNPID9TbV4oOP+iqYz/Dz7uIY0CGtVskp/iKPolE1OSg==@kvack.org
X-Gm-Message-State: AOJu0Yzsknezr6pkXOy/YtjfRE7IP4Mp+N6SXR82xfgLVIR3zulqOWHW
	3OkFjBIogtOEpaSUpmn+vL2nIj+lVYqI6PB8dAbChRLqXyx1h8BO+TmY
X-Gm-Gg: AeBDieu1/3Q/5UTSuBwCZTpsGVNf7nO/vfzelNeEWQyfGVp/ymmTCmf7xTdYpnUCD2O
	4UIg1jkf9iGH8jwpmwlHmiAhNZIWnkjwBf+Y1L4f74q7D3OcNRpWOwDvSdfgGZIL0AEejn+ADng
	VrCZeFdTFWjNiR+4+vFJVC3L4ijl2+UqUrNcyD1KKIHu4ENJMWH8+3nPMHRpdKxlAbcFUr4CEAH
	CziuQ7VPDKjVCBPSo4cRkzHl2y/I8mZc9Pd3mMhrd0GPNTgGHkCdVYVQjZ+LSw7cTxusLJ29T4z
	Gao/sRXqzhnuMs7VEHB6b0gRSfAaYXd/LsUVWzn7ESnqCefsURjbSHjnPQIRSVYy9Dmc34/LA3Y
	aDccjSMjcey5Im+WqqKNHrtdsxpA1Z2Y/n/0O3o/Nr5j4fw54pgt8aIazpqZR00QoJh5RAC07Bg
	5ndVJvCM1CCKwib1wlJK0IpHDvbH7IdugPyFq6p8+0lH9nh+O9miidMIrJyUrUl7FRHnub6oRTt
	z0=
X-Received: by 2002:a05:6000:4283:b0:43d:7ea1:fb53 with SMTP id ffacd0b85a97d-43fe3e15f7emr42641829f8f.33.1776953066423;
        Thu, 23 Apr 2026 07:04:26 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4dc24cfsm52984876f8f.16.2026.04.23.07.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 07:04:25 -0700 (PDT)
Date: Thu, 23 Apr 2026 15:04:23 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Alban Crequy
 <alban.crequy@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alban Crequy
 <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>, Willy Tarreau
 <w@1wt.eu>, linux-kselftest@vger.kernel.org, shuah@kernel.org
Subject: Re: [PATCH v2 1/2] mm/process_vm_access: pidfd and nowait support
 for process_vm_readv/writev
Message-ID: <20260423150423.1a428820@pumpkin>
In-Reply-To: <62d88cde-efc0-48cb-be8d-813eda810343@kernel.org>
References: <20260409142256.131676-1-usama.arif@linux.dev>
	<62d88cde-efc0-48cb-be8d-813eda810343@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 14jnyzok3fpamn5dg1aky7wkthx3w18n
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 88AEB80008
X-Rspam-User: 
X-HE-Tag: 1776953068-106190
X-HE-Meta: U2FsdGVkX1+jpOWdaezLa+FpZDJAocr38Hp6XDsQ4QI00yXGh0KuzWr3VpjAcFf0HGP4MJxl2Y19fb8ax2xmz7idxuxWfIGCuvuAsvXovybQT3c/ZzdX0zb6jeprTlr/e+Vh+aGJdgQvt1ZVE5dcCHwDbhyBMd3xKrx1z6u1sls37iX8+9JO/ofqEVw6w0OyK3RrYRdMrY5brnzYzyAPv6sdUYO2mlJJY+4sLuPSxv7kbv9SGXnNTq4Smg8C02diuAAAQhV9pqh4LEqp4k0NqfTB7qReto5DZHFn2UVduScl1Sn7tmsr1KpF71ZAcoPO0Xpnl4o7obtMU7diMsVEFvnY2f+uZleVa08Bc2e0yXu/X0xr0B8BdXFpjh1tjvjQi8rMtl/eTf7uhN6cF9uaZoAa46r80txcW3bAI3X2U6tpvv4zZRD/G2uq4D7SOPGZWWeXHuGPcdls+NtMZbKb21wburnm0rWM4INSqd63gbkcLtJj6z2oR7iqjhCvBH6zgQwOJFGtODfDOdvEDhlPo8fOE2ggCgo6CpyVDBKkybq+vVSv/nurlnW+FtJj0yBwAqbTJ5lRK/VVHegn8UhqR3zX0RJO8hsomUnf5edqukl3davlBdeAJKhYDe8/EGFz7jvHFDaJyfTxhZ7SvwwHDn2luiZup293a8iqB5LUbYmtxlM4VBLPTeQbVwLG+BKOK0fyeFLImBSVD0uiZ3671rAAr6ZkUZSgCS9WZBVLs4aKoPJjj2rXscgWsWhkynNd6FT5Vg/o7Z9jRUl+88YEinXUbG97EBii3/jop4xO712+1PQAwlmIJUQaDS1P3MU25qVEWWJrkBmog1/HtXXeUTb9u+EggEq6UbPX132pWZgIKTRQJXXFfpmqNMhg2yH0QvUsCqlzlt9l6N5MYC+5zNkRQd11TO8TMr3FNrSOcv7c0hpctRskpucq5wT5OdzDyfNs5Z7aa8Dd2ne9xNr
 CyTAbIG+
 yQWsGaxzhzwc7HcAvUNsX5jvG4XVo4Ud9ufCioOpatoRmxBIpMTm/je5dS2G5kcN7kkHAE/W94sqcaE8Lp/+nqW9wr/x+kIbaYp3NkQK8O3fDmdzC0p89bwgqnTQLa93Pg592I7FE7vWX8gTGxeSuXYlzoOxBdQUn2JlB8dV8wxL9cAdRfbMvrisELYKI9ITMVlY3apR3b6tMaqrZhM9wTOs2QjEthAvLHXJRwo0t5pnDHWWD/RLeFqZzcZYtC2t4wz8hd8013F/3YCZRXwjIBOekR4c9wBmFaoSelq1Ab6+xbW+4lVnldWdqOMJJbH67H7zMAglrC9EGUaMjuRinll/g2/X/TeChS8FQ5oNdQJgspek9LABkxuS8TJ9QFTC7gCr/yfslmcCu0w7kZgDvUHuaoLZqkqriYZdtwA71e5eEXxbhZO9Up9SgUTj6d8RLhj/aF1VFjwtf/VonWLkbYppigmK0Qm1R76DzedD1XYaFSWD0gGLSa12oiVhRQ646di9lzWe8cA6VJHKpk0VzSLr7l363oWA5+Y3hjiU2eY+C3aLh+nW/JFFMNHNApG4uT5zD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Apr 2026 14:52:26 +0200
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> >>  
> >>  	/* Get process information */
> >> -	task = find_get_task_by_vpid(pid);
> >> +	if (flags & PROCESS_VM_PIDFD)
> >> +		task = pidfd_get_task(pid, &f_flags);
> >> +	else
> >> +		task = find_get_task_by_vpid(pid);
> >> +
> >>  	if (!task) {
> >>  		rc = -ESRCH;
> >>  		goto free_proc_pages;  
> > 
> > pidfd_get_task() returns ERR_PTR() on failure (e.g. ERR_PTR(-EBADF)),
> > but the code checks "if (!task)" which only catches NULL. An invalid
> > pidfd will cause mm_access() and put_task_struct() to dereference an
> > error pointer, crashing the kernel.  
> 
> Yes. Should we add proper selftests that exercise these code paths?
> 

Probably worth checking what happens when a 64bit process tries to
read high addresses of a 32bit process.

I remember trying to grok the way this code accessed the iov[] and
failing to find the appropriate access_ok() for the accesses to the
target process.

	David

