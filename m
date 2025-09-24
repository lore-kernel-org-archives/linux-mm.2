Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE05CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FF318E0014; Wed, 24 Sep 2025 06:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6968E0001; Wed, 24 Sep 2025 06:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4968E0014; Wed, 24 Sep 2025 06:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 274A28E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:05:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D016887972
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:05:09 +0000 (UTC)
X-FDA: 83923710738.13.F4834CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id BE30020014
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:05:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=URi53Ks4;
	spf=pass (imf13.hostedemail.com: domain of minlei@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=minlei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKcp8RbB9qIjTq//aq8x3wJaE/cjRo/2DCN671q8C4I=;
	b=lAHR0Th+XG9RyYLFHA9CR8o2ENLhhiVDRrw+8zc3UC+fKYB1pjmcNZ8w8R4+YJAoIc8xFJ
	VLpkVvcoGbe4oZ4tWfM93JbwIhc6fGepOLBkz9ICP3h8USpO1DTFr9qPcnDiQ0WwkyTRcA
	djME+7xG+f4RL2PNaLHZ5G82KOFycHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708307; a=rsa-sha256;
	cv=none;
	b=l4h/Q3cR7KWXif126sW2G8+U83Kb0NZAsHDKVNLNZB6iy/0vqazc6Ax5XTrXrLha8HKCoT
	rCmmwBAUhkpEEoqa6WDlnw0Ohw9Ml88fcLtDwLQzRj2rZv2H7CyC69LIi7dWDkq1LFTcCe
	3VyA0VdFOdSr4yTHle6b0a7E/YOpTwk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=URi53Ks4;
	spf=pass (imf13.hostedemail.com: domain of minlei@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=minlei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758708307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pKcp8RbB9qIjTq//aq8x3wJaE/cjRo/2DCN671q8C4I=;
	b=URi53Ks4awZZ7iz7T+BmOnXPrREnJSaGpWAX7IdnW1OO+OIdDkTaMBvb5yGW2e7a4f9OVw
	BSI/80sn1yNdkFq6CjiFI3XfQF/hu6jwTICxH0GlD1PEHf5PgA3T5EgWKCF6vQD6pjHCOl
	jJak/bN0XkUJT69H3hgNkDINno6yEWU=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-IxSMXnZVPSOW4S-jk0tLBQ-1; Wed, 24 Sep 2025 06:05:06 -0400
X-MC-Unique: IxSMXnZVPSOW4S-jk0tLBQ-1
X-Mimecast-MFC-AGG-ID: IxSMXnZVPSOW4S-jk0tLBQ_1758708306
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-54a87b8f9c6so1504389e0c.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758708305; x=1759313105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pKcp8RbB9qIjTq//aq8x3wJaE/cjRo/2DCN671q8C4I=;
        b=LDP2T/xQXfoPH/LY0Ly7w6DXBKRpM9SFRtuJxlLGuIv9GaJhCVDlrL0RDfpMpenlXL
         B9KTKZVjS4XO4++EXkUZZvV19sjJC2BqEk1s775+9EHCYYGKcfLRMusNM1VQ0Ccv+KOd
         a1AkHohViVfYK9m1t7f8eeMmjMZVQ+0hgu3yJyPo05cJmXS65OVwn2umCiZqQbzzgLRZ
         kiQox7XqRMC37mdCNC2p9+CrSqJbH+497C4JGrEhlF9NaDdFaFH6VwmRSzLRpHOdRBxp
         Ku0qo171YXQE+H0imbI3mc16CQpqZ8uIVm1dtq0m0XF2ch8YsZeuKBTzneJeOBfWaY9z
         BUdw==
X-Forwarded-Encrypted: i=1; AJvYcCWbs1agwgcgCj0EvX3vKqfHET2axUpXMqNwWw4r2hGMUMIOfKsHZTHb0n/UkrVReAHg7ufMhCS7QA==@kvack.org
X-Gm-Message-State: AOJu0YwwsRjKqfLwvUMhhY0VKkSBE68xo2Yw/NWPPg4i0cQQJJjlKNiV
	HH8smVPAKqj2wb+a4nor4basNBgfgZU6N/t//WNkDJbG/KOaW7KXqmNIy+uVn96empqW0RQ2T5e
	2nSNYRbcCKRO995OQ6d2RcbezdmVo+58zHeFN/RIMdB/lxQbNhcFSydrCDkevPWsZIW1sLaTzdw
	vzxdqan8tY3xnzoBaGLlu9nK+dBQU=
X-Gm-Gg: ASbGncuGAj0JQWE+iLd1QLtUaajLFZHLI4G+bVqy7UBrnJO11VLRC4T6saRewLdUAiD
	7Ft3KWOLL2Io0v3BafCR1zbbiw6VIcjw1t1W1Mg1VxqoLVvKXJQsdgHlsgkONZHiOp8D+2PZ3sb
	ajs6Xk0yNQmdmrGESSlkQ9tw==
X-Received: by 2002:a05:6122:46a7:b0:54a:a874:6e4e with SMTP id 71dfb90a1353d-54bcb11e0c6mr1653528e0c.8.1758708305565;
        Wed, 24 Sep 2025 03:05:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPptVrEMQd0wcOTvVhc2Oe3+W+CQLov4+tsA34aiA7Aw3gYYXeQI2LOHtMUYKKnuN1qYBzcewy7H1XCDRJWDE=
X-Received: by 2002:a05:6122:46a7:b0:54a:a874:6e4e with SMTP id
 71dfb90a1353d-54bcb11e0c6mr1653503e0c.8.1758708304461; Wed, 24 Sep 2025
 03:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250922032915.3924368-1-zhaoyang.huang@unisoc.com>
 <aNGQ66CD9F82BFP-@infradead.org> <CAGWkznGf1eN-iszG21jGNq13C9yz8S0PW03hLc40Gjhn6LRp0Q@mail.gmail.com>
 <31091c95-1d0c-4e5a-a53b-929529bf0996@acm.org> <CAGWkznGv3jwTLW2nkBds9NrUeNQ1GHK=2kijDotH=DN762PyEQ@mail.gmail.com>
In-Reply-To: <CAGWkznGv3jwTLW2nkBds9NrUeNQ1GHK=2kijDotH=DN762PyEQ@mail.gmail.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 24 Sep 2025 18:04:52 +0800
X-Gm-Features: AS18NWAzS4ovR9ej7R-yAyhG3XtRFr7Vvnznyh6lks2oABccTIKfG0VXhGRlpdg
Message-ID: <CAFj5m9K4yv4wkX2bhXSOf141dY9O96WdNfjMMYXCOoyM_Fdndg@mail.gmail.com>
Subject: Re: [RFC PATCH] driver: loop: introduce synchronized read for loop driver
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@android.com>, 
	Christoph Hellwig <hch@infradead.org>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com, 
	Minchan Kim <minchan@kernel.org>, Ming Lei <ming.lei@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q5z2XV0yu30VTHRpBdIEkJ_5VAwPuMnBUgwrJXSt1CY_1758708306
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE30020014
X-Stat-Signature: gfnyprpw8br777cgd6z9pjhe7pq1iedy
X-Rspam-User: 
X-HE-Tag: 1758708307-680490
X-HE-Meta: U2FsdGVkX1/Olig63G+X7crX7+KKQ20sQGt1wwlmMGh646nbvwLN01fbIH7Dp9k1kRizzlut/yyJ1/W/NM9y9iXGsCYZ8bQ1qSL6rxSSDoifU5wuyi5mTfufjwDq9wfPB8ZD6dB7p6/yry9ynkFkFLLPZOcCyRCufhULY0n0YcDKm10EYZ2pJpx9gRQBEv4kUyrw6CwSpIBEul5F3hkmu3/M1NMMBfYivtWq/XMVZoW0AlXbfhTlXhTRwWeeKGCw8k2JixNeZq53WzSVxhGWIzz2mC9fJRmF6Y7BKr6exBVrFw/RJOrCu5k4xJyt3Ck5l2Ez34EVyt2iMXb10U11buQIGC1iXaHcX0xAK+gzE/IAKqf/DaEWbXl7k7mDcF7KRM2ejymiLNmlvJcN4AVBoMrb/kk1X9W5OFbFQ8sPLrE5bkiGfTGMvWV5J5PSZpH5kNG6rCNf0580qTEe6pdZ5LDXozHqIUhdUOZyTmgUX8uKOgebT20ykmgLL7FYPiyeMJbaEn8X00bnkOfM/QRwpmSYtFbibUGU9OmAhWx3hclo3uCYOTQNF/a6IXMW9Ce42mX0nRu1dWR1fztTkeSsojtUD72r0GXkOHV0rz8huNnSmLJSjXbwiN29RZpzLsELiZ14FHeKR0GAZ8/CaxujT2yQPJ1YOY9zYVHzrutE/maQkxSkDFGE3aoU4SnbI/P4yVqIEkQK4P+q9XbSpJga4dgOZkD2rvVQxqUU6UuCaLWt0D05bOasSYw6CLsBh+tyNggTeTRgq2BETTx5Qei/8k4NkSAVKVORUFpbGtzyhvWh2YznFEsC9WZNAn1Om0K4V8iYdKfx0q7dd1X7JSe47OQRO2BuPuCNX6fX7/OvOGOtk1jHrlvsjyZBya2Jb9dx9B37MUkHcnJmqorU5iKwNojeJnBXJdfjPCK8tD7Q2bNd4TVVrlruE2Hp+cO3e+tOZNQ+zwUBb2CWuHnV9Qq
 7Rnr3CV6
 lsFWXU0OSU7MRCBsQbyghOBFTlvubvZemoxUFgmfYGOJ3atxRYBORhA9i/qDtPQBTB80Z2EaSp8SXVjP5BMcnews3gx5ViWwxVoLI7XV75wxSY97i2CRjpuphXcLpXwUgy8//TZPfgnryvxzAMnMreGEOeLJD8s8173ODy7Huhf4ppwIILihMnfhB0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 5:13=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gmail=
.com> wrote:
>
> loop google kernel team. When active_depth of the cgroupv2 is set to
> 3, the loop device's request I2C will be affected by schedule latency
> which is introduced by huge numbers of kworker thread corresponding to
> blkcg for each. What's your opinion on this RFC patch?

There are some issues on this RFC patch:

- current->plug can't be touched by driver, cause there can be request
from other devices

- you can't sleep in loop_queue_rq()

The following patchset should address your issue, and I can rebase & resend
if no one objects.

https://lore.kernel.org/linux-block/20250322012617.354222-1-ming.lei@redhat=
.com/

Thanks,


>
> On Wed, Sep 24, 2025 at 12:30=E2=80=AFAM Bart Van Assche <bvanassche@acm.=
org> wrote:
> >
> > On 9/22/25 8:50 PM, Zhaoyang Huang wrote:
> > > Yes, we have tried to solve this case from the above perspective. As
> > > to the scheduler, packing small tasks to one core(Big core in ARM)
> > > instead of spreading them is desired for power-saving reasons. To the
> > > number of kworker threads, it is upon current design which will creat=
e
> > > new work for each blkcg. According to ANDROID's current approach, eac=
h
> > > PID takes one cgroup and correspondingly a kworker thread which
> > > actually induces this scenario.
> >
> > More cgroups means more overhead from cgroup-internal tasks, e.g.
> > accumulating statistics. How about requesting to the Android core team
> > to review the approach of associating one cgroup with each PID? I'm
> > wondering whether the approach of one cgroup per aggregate profile
> > (SCHED_SP_BACKGROUND, SCHED_SP_FOREGROUND, ...) would work.
> >
> > Thanks,
> >
> > Bart.
>


