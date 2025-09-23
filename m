Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83056CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 03:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE38F8E0013; Mon, 22 Sep 2025 23:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D942F8E0001; Mon, 22 Sep 2025 23:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD11F8E0013; Mon, 22 Sep 2025 23:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC2DE8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:50:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A541C0849
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:50:51 +0000 (UTC)
X-FDA: 83919138702.16.58BB3F6
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6E4D840004
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:50:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cKkvjzpS;
	spf=pass (imf17.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758599449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9rIm2Qr+sxmWg43C3LjSRMHytvWzDOz0PNv61PwIN0=;
	b=aog18wq7maIHdYyoMlvVQYaE4tkIHHS7bM/s67c0dSa/hMI/iY62RL5F+hfckHX0e9U2Ws
	TeMqUr7QnqC9k+32isbTEUrFl1ZKzqU5+DJgnMvbi0GMwObOzLmq57Q+Chx/PKuWnqZHKi
	6fdqeyGfNKB8c+Ts3rwkw4w9/ncHfKA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cKkvjzpS;
	spf=pass (imf17.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758599449; a=rsa-sha256;
	cv=none;
	b=5NmtsfN4CSiuOgY2WCS37s1/sQvqZSjxL+n5iOsWdWeyIlVl9UIL+DRpeWm53vRQkSFV/B
	Bg6A8PlOTTfi5VkLRRPAvESXDj7ynOu2fB1MV+nq4avgYVxWlNH1aJnUvMOA05k/OeKDDU
	6f6EnvyB7Rg1JxgzWSnWSN4q/AW7We0=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-361f9d329c9so6635241fa.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 20:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758599447; x=1759204247; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9rIm2Qr+sxmWg43C3LjSRMHytvWzDOz0PNv61PwIN0=;
        b=cKkvjzpS8tJOvKE0/w4ZK3/3gxiOHsRGRrbHb5wzrDGFbSNoo/V9V/jxKCXgvL6c2/
         dvAgzJCVci0kykekNPFM5jhozE6iR+BlgqWqG/JSvjK5xdaAhD9hbh86C9EC79BPUaH2
         AfoxDt4E7vTK+XSFMWdaSA3hgF8DnnDwovcSlB6wdcoUvLp7tXuNs7m7LR6G9ZflilKO
         /Pj1nvZoWHrmZHWn5BGOI2R0tQqP2cebGvulH9yfjiUPWnP0xgqADCk7WDZvwJE4xR/1
         A/XSsDVAjZTsB/NykUh2Jx7WWsfQvFyX0jcDDHChK++c2vuDCVVHyYL1cq2SbKnGs1RI
         pWlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758599447; x=1759204247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9rIm2Qr+sxmWg43C3LjSRMHytvWzDOz0PNv61PwIN0=;
        b=QsNqj/Aj4FH2mVhfdccbq7dfMSOcMkJ3qmFsD+qLBl9t1mIzlGMlqxlcA2+HOcZdr0
         i0+QCGCJgcXon/QyvASgkD+t82fgHnPbGSk8H/xxHexe01Fd2EYyIv3or/AxReWmMU3Y
         +J7XCED0rtZTRyHvtY8o/iv5ekcu6vZ6wRdOcgusRCo3a+wBpiH+G1PB+mB4m+c8VLCw
         SyjZlnmz8RLM/CESOaGwzMyIdFiTKPduwaw37fY5uyUN+FsiqM2DrHkZviUfKXdHvfe+
         yDJ2lWddNluFUw5sXFW7mivobo4llihLV3XHNMynvgtfM5HzlGmq7KbnPJVeuaeev+S3
         BRyg==
X-Forwarded-Encrypted: i=1; AJvYcCVvmFDkVlVmIVTNjlx1TE6w8U69N12eCzasL7mjLhFCAksjqv5pdhICqyoniXohbzwJd/xSCic0Kg==@kvack.org
X-Gm-Message-State: AOJu0YzyAdBKGNP+QbmQ8oTiA1oakC/0hi6BL2z8MtbF0H1GX68x6PhH
	/R/kyBEgJhCuDyiXa9n4xc1vjMXk+B1ycGoSic7xlLj4ULKlSRPzDEtapku3VIo/5keMA9WKEUx
	cL2FfJ5krO42uTL0zOQpEDzpSjkSqMEo=
X-Gm-Gg: ASbGnctjV0OI51TOhZevIdTin77pN+qk1EGnXiIJaF9gSoh5pVPVAG6rlDL3DtVk9YJ
	EeKzT83/n84IvjkqGSiwb15Qb/DNOC0fam7PYrBI1dlW4ia9NNYCvYma+ePFQUzc5bA56Im1gMs
	epV7pN11/Dmo/18hgPd82IJEaSJCys+SVSzRX79PkiVaW0NoeuUGRrp1c2Vysdd16HS8AA4zVoL
	+a+X0OV
X-Google-Smtp-Source: AGHT+IFPR/ojxUbcunSqFj95BptI/0qdsAjMPxxte1rg/TtRftlIXBiGgzI+t0qpAtOcsZydxPV/Sc/0QBJ8p57foMo=
X-Received: by 2002:a2e:a587:0:b0:338:1a1f:1152 with SMTP id
 38308e7fff4ca-36d176d9e37mr1511201fa.8.1758599447268; Mon, 22 Sep 2025
 20:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250922032915.3924368-1-zhaoyang.huang@unisoc.com> <aNGQ66CD9F82BFP-@infradead.org>
In-Reply-To: <aNGQ66CD9F82BFP-@infradead.org>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Tue, 23 Sep 2025 11:50:35 +0800
X-Gm-Features: AS18NWDFEH5uLKDpswEZriajtkKtRdC-YZKxVLp-mDKwLqx69RhYurkjBEuTo54
Message-ID: <CAGWkznGf1eN-iszG21jGNq13C9yz8S0PW03hLc40Gjhn6LRp0Q@mail.gmail.com>
Subject: Re: [RFC PATCH] driver: loop: introduce synchronized read for loop driver
To: Christoph Hellwig <hch@infradead.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Jens Axboe <axboe@kernel.dk>, 
	Ming Lei <ming.lei@redhat.com>, linux-mm@kvack.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bhijzgdegnopem1w6comezi8mj8fqo4w
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E4D840004
X-Rspamd-Server: rspam04
X-HE-Tag: 1758599449-595909
X-HE-Meta: U2FsdGVkX1/waiWCFyVGssNmMyawcZba/FdIIh2zurElrdnJYLVP+8qqLkIFxzaFFbsDNfHjL7goV3B793iTzzSHTz709UXReKeSBtAi75KCy4MktYyosrf5/G58lQbZeZxjvBP5TUWb/npWR709V7UMov40p5EdyKxG50c3r+l1x7MmmCIwMEd0m7JY16JNPhq+dfM1HGD59YYbpRPoYg71wl8uZQvDJs7XYMCo5OIRaOQc8btHsuBb2djaVKk/55vDLw95c+z4a41i1rVglxmXrKV8z6uczWpoaZkl2vJB4ODPawN9yZpobQOBo3OOBfPhifHlDK3hYs8ieeKcsAjUd8m9VogZyzN2PuTMtUy0BHgKzCvc4/jN6vqfHpSVPlTRS3gG1CbBslgQNZf0SBvagDYYW7Upo387vmsw0UYxTrOcq5Gw3p83aUu/b7M06RARmaqnryK1oR07hl+84MD9LRHK7PxoLh8S2iM920YZ8nowTTTL9mmgXbljysQYoLIJe2nQbUXpO7wbHvRsooYLh5GUnNPRH+6X4u+VJpogAWoY3FM8KgSoLYRl4oG6UMUFx9JfKikytwqcnUZhdzZ2LrC/AdG7rkuPTJbnZ+pOHUF347wg4/+IgwRA3PC1fkxGX1cn0pM6cH+L7QXBJBGtQhJXWtbmp9WFHqJoysV4Vp2Eh99jXSY0AXzqS7HZVltwYqcdZh8Ppk4D9vaYow2IMGF3TPSnOoF7qp398eRZlM+e6xyXgv1C5ozErhhK9+af+rzNMODZqadZxdZL9Zg2LYjmB336bufH+9QoCrwDADPble3c/qlCAheN1F48/dkHML69lQ6EBQenJbhtKHc7QhNrzMBjkv3kvxw/VzZb9bBAbOfA0QmL1ra4Wtu44Y9hcNKf0oZXO5polRVVcMEcCBknNE5HO5uPKpSzs8x4ZGhyXbxikJHvzBkmIETJAi/RUtDq/U0WVWs81Bp
 e0Q8vV5A
 FJ2/LFPJK8BhIBMEhmEzjdkyHjRdYEptpAMwX49B9IDElcNmpnSQ3vYQUr9sclLSn0CXBXo2pIONdIvCmqwcs0CYSXQ5IpQLSxmBBmSXoYg10R9MOsBZxoKzHwP0v+8rJHuttatbDaWxgffq95EGArpirFU27n5Y3wrYVIuKeBXOy3AFkOwWRsjxldFDR7dB0MPKkHOqOnjrOgjyQ5arKdvpvZLjMQ47f09udnPhC/aAAzMRJCaSRt/rvoinP5SjFG4rgeYNVrkkUWUN8GOBR/loTITqr1MRWDvXLPgnDYOPW+UNMCECG6U2lzM8IS/PBwU8lBkPVvG/+s7uXFRjfbtjAhfQbsISbtbhp/G86xNChbZ+JOvlBOtGVBg3EP6crJzTsLJmb8sBtl4xl+VdmVi2snfuqVpqBgkDqgRtLm+/gFWNcV9Mhzh0etQxYGyrTiDgAjlmIsSirdBe9Y1cDSoyR4zkD9FAxe47z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 2:09=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Mon, Sep 22, 2025 at 11:29:15AM +0800, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > For now, my android system with per pid memcgv2 setup are suffering
> > high block_rq_issue to block_rq_complete latency which is actually
> > introduced by schedule latency of too many kworker threads. By further
> > investigation, we found that the EAS scheduler which will pack small
> > load tasks into one CPU core will make this scenario worse. This commit
> > would like to introduce a way of synchronized read to be helpful on
> > this scenario. The I2C of loop device's request reduced from 14ms to
> > 2.1ms under fio test.
>
> So fix the scheduler, or create less helper threads, but this work
> around really look like fixing the symptoms instead of even trying
> to aim for the root cause.
Yes, we have tried to solve this case from the above perspective. As
to the scheduler, packing small tasks to one core(Big core in ARM)
instead of spreading them is desired for power-saving reasons. To the
number of kworker threads, it is upon current design which will create
new work for each blkcg. According to ANDROID's current approach, each
PID takes one cgroup and correspondingly a kworker thread which
actually induces this scenario.
>

