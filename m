Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E4C7CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 18:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689576B00AE; Wed, 20 May 2026 14:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639EA6B00AF; Wed, 20 May 2026 14:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528DE6B00B0; Wed, 20 May 2026 14:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 40FA16B00AE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:13:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6550C19D2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:13:10 +0000 (UTC)
X-FDA: 84788594940.07.8616CD1
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 825354000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:13:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=eKJoDGyy;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779300788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYgHJgl7v7AMjSACBzl5tUyhrihHZTaaSUQTTpBwaS0=;
	b=UUOdlD3aj0spE30sp0VmZp1lJRGs2IPAaso0hVmWVgzv2sKjvvSLCKKn7KoLJznRKXfGm+
	++Y4a5xsomb8c9nFX3VOHbbaqoexPtWspt1bughrURmmpOcyunjMxWU3/E2gStj+IDduQ7
	LAolCQ+icbeEb4TKpKJccWXbpdQOI9U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779300788; a=rsa-sha256;
	cv=none;
	b=h+DIG2tEvB8IDy5l2AQBa0Bnob/LFtrY/JpGeAevllJZOZFgeshG9RN54sgqlKlZbNt4w8
	snRw9jfvCoWB+o6dapLF4rwycFQjbVYkbwrpmMjiuagyW1NNXUVk9BCM4JzNGfaulWyAOT
	EX/Ibl8dF8fEJvODCM+PGxGVKEVl38I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=eKJoDGyy;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-67e9e343b22so7771198a12.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 11:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1779300787; x=1779905587; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SYgHJgl7v7AMjSACBzl5tUyhrihHZTaaSUQTTpBwaS0=;
        b=eKJoDGyynm2QqKLq5A9QvcNwc2xKzke91GCJixhvJSpNNZCspiDD8jj3ISIA5y7IDI
         ccGHpGnqLnFjGYscaBVo6a5klwcw0d3UM4c/rbGxWEfbrSyF7D1F1bDq9/G9ybWpNW+t
         26nlx+VLkaJ86MR0cPqpZkDPQ1mCKwQNoLs/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779300787; x=1779905587;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SYgHJgl7v7AMjSACBzl5tUyhrihHZTaaSUQTTpBwaS0=;
        b=f8vYPPZM9H6rWq3ZWlAMvpgFblRk0XhF1CqesP6abokd4zp6eWiXKKQdH+8ZuMlQWM
         0St1fY+KsTs4ql5UCUHjzwoecrXZKEwBuDjW3L1WXzAg8s6M3rZmNrvpCMg/T2snqXqf
         5AlfNIVvMxCBDpAPOZ68AZjzuV1gP5sIIvQrAhUlK8nz1wMAP7k9mWNOxuLHJytzPzct
         cjP+v7/i/EfluA7cudXUq98qoRY1nJm5KgupzXynS5AzRIZIMa2zVZYLPb1hVnzbD4m6
         inVLHTXVVmBQRrtoV262qIRF4WTHMnpp8iC8zD68QR64UVNC0Uu8MD8TFaDGnV9FQNuN
         TOIA==
X-Forwarded-Encrypted: i=1; AFNElJ+OyH9Qh1D/bgDjaGL+cba22tiYb2IcURWklOVR2jh/1oqtvkyLVCvIYZF2uEA9usci1vc20rQslA==@kvack.org
X-Gm-Message-State: AOJu0Yyoi3r2b9tr3L5w9wR1r5S8PRPU/cenTfLdX/WycH+1mJhdlB+s
	nUDeOggFVhOG/5Pm4EQH1Bn9gsDiRzHN3XHvPaEqx7PpP1eJGaxryXrcs/DvEQuuUF6P2DLJWcv
	rL7Vd/d3FDA==
X-Gm-Gg: Acq92OGM4oWsw4BbjzTM9lMal0D8YxVMJQ4viZif8R0p2MjH+UJ5O1fwP91/XdDC1iG
	iu7hxgYPFMGkZq77lQhsmTICyhnYyMmw398A9w0laQUCwB9B9NhIxKMPuVGY9E6hRZPx+9Hk0HW
	cbFBOmnOGsemrqieUnJ8Xsy8NPmktPO44ka1x/EddDVD/H0qeNvvXSnk0bv00VaQp5bwBLermI+
	PUwRxvc5gidv5XXvROa8RzVNPXl6DjLKkjrg/LAA36dZ1xPi4GE6U5tOrBuoeph/959cberwP5x
	zEhcXs83DVbgm205HKAZhXeFdv2B7xSK3ElRrl2fZYh7tBkczaAqx+to8RzieaD8jGK8ZF2zc2G
	B2v5Bt7ma1unQWU1bAHj3v9wMuwXZBdExkc6+JmrsidRZNJKPYwoMIXqMWbOITFhmAPSB1Y2RUG
	uWaVWIYHslim8IPCVJJfC8K/LIhcVRnLzm3iiasKOs1U6Cm9/1mcR2pHXH9Dh0RI1AojHZ6BU=
X-Received: by 2002:a17:906:514b:10b0:bda:3469:47ac with SMTP id a640c23a62f3a-bda346947f6mr312032866b.42.1779300786826;
        Wed, 20 May 2026 11:13:06 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4dea93dsm888094766b.38.2026.05.20.11.13.06
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 11:13:06 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b9358bc9c50so790620266b.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 11:13:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+UxKI5n9VhOVJpNAG6wupks5NETFEu7p4Z7yrGONJP4kUSVFPFii63q5UEAjXW+LdBHqK7TTjvRQ==@kvack.org
X-Received: by 2002:a17:907:199a:b0:bcb:4046:63ee with SMTP id
 a640c23a62f3a-bd51792a4demr1442312966b.31.1779300785967; Wed, 20 May 2026
 11:13:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
 <CAG48ez0kVA+Rw+pHSi5-JLf9KTh8Y9Am04W567YS=imgk+b7tA@mail.gmail.com>
 <CAHk-=wh7CJo_GmRoByrMePPB6sDC2ienhEd8riq=xp0BLPYZYQ@mail.gmail.com>
 <CAHk-=wgfOvMTh8Tbkrk8ifHw_aA+vfacLs-NtULpqx1sN+y01g@mail.gmail.com> <CAG48ez3WUjLY2iV2_BmJB1RX6vQ+5czYNJY5UP0KHZLvob_Ztg@mail.gmail.com>
In-Reply-To: <CAG48ez3WUjLY2iV2_BmJB1RX6vQ+5czYNJY5UP0KHZLvob_Ztg@mail.gmail.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 20 May 2026 13:12:49 -0500
X-Gmail-Original-Message-ID: <CAHk-=wgtQ1s9r1zaBcV6vau5vBd2zmYyhH0WqY1KfjyvAseB+Q@mail.gmail.com>
X-Gm-Features: AVHnY4JLbhQck2rq9Oi7SqoG56hwdBYzjccM7jAoAz9oDGzZQuC4GJAvSMl3F5c
Message-ID: <CAHk-=wgtQ1s9r1zaBcV6vau5vBd2zmYyhH0WqY1KfjyvAseB+Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/5] ptrace: keep mm metadata accessible past exit_mm()
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 825354000C
X-Stat-Signature: cc6dws364g7dhhac445tgqjp5rzuzfyo
X-Rspam-User: 
X-HE-Tag: 1779300788-664072
X-HE-Meta: U2FsdGVkX1/q4rXxwjRr5nVj0/UuZE+LRsSbzB3y9QwVY0jmy45iv6PUZcIBwKDqQHB/u3wXJxmIvTj9Gged3ElNmkTPB1Y8OH+/JfYwvRN+lv5QnvLz/w8XNR3KcXla/LAjMIcRQtGRWFoXsacD1UG7iJVkErhJWUNMSQb28GTrvTWr397VQ4Ku39EMRFhStd83DAi5e9l/XsXhhk8d/OmOSxvGjqcq2c2lSDpP9CNEv2nhhwNgByQMwsVUicBRBzwz1KXtOK7ZoR9/nKxMwYh8lGzX9IPik8WHVMYApWvZJs59kZ6ceIhEEqnk5TpEKDZ0HFx3615KcolweEcUkVvn+4yQV+RW/f/HAiUzozR9TiAKvisMFGtwB7HQB6esvcZ0Sb1un63S8Zlt44tG9T/lXJvdd+lNzvi3DMqzMSnKhahXusofstu8iclTF5og9/prsQWqnBYKotoY8Rt3wGcJXF3NsPh3NXCAxeT/xyjSNuFhTAM75rXov6Xq2TQgOhC+2DzHoj2lDm30hRQNr2EIPRN+fjxYnqNOmkpBUdwz++MEO1bME2x/fu/cukIR42vFMzivETIFfmrlhxnDWjMIjj5pK9xJVY/ZPXT3kfzBL+LU23+t7d7O8EP10Esaer2VFUZSM6ThZilOVCXEgxcaCqBMoqWbZ6QAEYMMLYQxrKzBAXf2+w9Ln0wkopQzIaTjKYtSGZQCfbT2cxWRvtC5788pZH176nhqtZ2ZdSwSVdMDiILmoYz4xTTZLBpaVNC37nv9xukBFYB/6qvD6wKXoglMYWFmAlvSTZssSHfUVCNyFdMQteG9BkF3OKgakC6xke8HSUZsUWInL2KkqtfbxxeAmtn7lj1CWDXY2A0HFPybdQRqGOVK3pwrtOwijiMQ5uSbc3Qf0eJFh1C5Pr+4m1bEYZfRQc72z9CesfIo0jzBlK7G/cKApdP81ZyIe8t0NDaPe+gJKy9NqiD
 BmmEXzwD
 uZgj2JbzbRYlNYLr9ss2ul/WDkCZ0x/s26+EbFsba3aX9xbWFElB0tsdm1xp3qc3UyhgiBitib/NW6b+BxBDac2KPekUT0gBXEJyj14chckrYAvNna42NIGN08y2Mu/j9EahH2wWQIot9JX/6TjZi6riBKbSxWDTvzTXEZb7MogbDLlXva780Qo0pSkCZIUNrK/OlNj6y1oblhKDEKrmJRDGnTtVMWO/LzX/Vo2IMCWLgAZXFLgW6D/YQSlrRmFtVeJd8Zc+NSHjI4LVpULX9pQbt2fzRFSUiV23uOJZAqgfYUCjMWij03sFQsSeVqtv4cjFY5dVGaiIdqJvmFjISbrbDo0kIiG91mJA6LII9XFO/I6udlaYA1Laxye1uw2p9F7v3o1ssZfTjzYoAiz6OFn6D6DwZZOjahhuC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 at 13:09, Jann Horn <jannh@google.com> wrote:
> This patch series always unshares state with alloc_task_exec_state()
> on execve(), and never on clone(). I think compared to that, it would
> be strictly better to also do alloc_task_exec_state() on clone()
> without CLONE_VM for now, to preserve the existing semantics.

Christian did do that originally, but I convinced him that we should
try to aim for simpler semantics (and imho *better* semantics)

Oh well.

           Linus

