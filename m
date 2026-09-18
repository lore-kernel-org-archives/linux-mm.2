Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0939DC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22136B008A; Thu, 17 Sep 2026 20:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8B86B008C; Thu, 17 Sep 2026 20:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC15D6B0092; Thu, 17 Sep 2026 20:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1BF36B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:20:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36BE91604EF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:20:11 +0000 (UTC)
X-FDA: 85224975822.07.A7E3A8E
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4FB25C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:20:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tAfZcyOw;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789690809;
	b=oacUFSFTW9h7r2uz+kgOH+Wix14hzCz7qPkayQV6tAM5xlCT0jr+6XwNITAVSj5Xzqa4Fg
	1OeNgTejJcbyPvMJ8JuZjHQye8gpYeDnQjqrr/YhAL5KuA6K80MmOB92OXOpPCS/biU4qx
	iCodRTJab8RECsVm2sDle9ofFDVHdzw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tAfZcyOw;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789690809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwBdK1wXdhnqC5rqC+CqcOIhT5t7NUEXcdV+4Bz8D78=;
	b=3cnEShAXjkzM6gqQqNzdyxZaB4BW1SptsX8d2uF83l4zDSEvZWcnjsxDbB2fUs1b/Ng5zE
	FOOblwDubfVBrnao5mFa8//28W64u7vpS2uTx+P8t+p7/KvM4l4M40DnI+EYTWGaVPyNHP
	QgX8nsFeMxqKeht73ZBAaT/YzF6/RMM=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6356f6bso84992f8f.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:20:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789690808; cv=none;
        d=google.com; s=arc-20260327;
        b=DzjnZ6x/4Ar8KLhmxQfV4CHnNAZoCj+rYovKXfn4rho1YHACgtgDcfUalp6PZROLlD
         Qrw1di8M8A9+NW1VvAvNg3Sos1ARhHq4daRM0HtNlOVzUhWdv21b5PX/YvA0mdWfM7eN
         ws7SWiYfIZ/bYw1gUoRdKihJ3c2rCDM3wBACNmZouEUP3TVwMcJI7DT7aAR3qtFlQJHM
         rvduZCLJDTaLvJdvyic/BOoi5aADnKnM81pBIFg4cyDTsew1Fi6g+khn4yvL9K9VdM3N
         f7CrruqdM+LbwLSNqz3TFcQ9ozRxy3YNENE4fu2PWDRRIBygwbevnFdHo7kYgoiszjXY
         8b2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rwBdK1wXdhnqC5rqC+CqcOIhT5t7NUEXcdV+4Bz8D78=;
        fh=Mku5TSMXRT2R+rAT9VVy4aA5vRpquE1HQUuZQk8RgVc=;
        b=ofjwK8/Ua/CpLbYkGN207/tUD2fo+WhAvC13el0wghNLOZdKHNfoOeRhVDKxr9qUYT
         eQGA13gYUfGQBU+jfKcuMKH5jtwX7J7e78JgSTY1P6mcjmUoa3l07t9KjtakjPXQCXEY
         9QVYzyYmjFgjnK2E8oFjEZrCkWxGwNoXas1TwlbCgbx02mtMz3NJSf2CK+mYBySuh3XK
         GOrqDtp5RYB/dKYBzIzBskJQrqHx7UopuRrPG9hp0uWj3l8H3JTmP6tPsGxOW5tQtMT/
         0lkvBCCxMQZLLi0jaXW7L8ACGlP6b5BytrlqBBK6vj/yaYGDSlclYPJEuB4/mGVbQvxC
         NK+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789690808; x=1790295608; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rwBdK1wXdhnqC5rqC+CqcOIhT5t7NUEXcdV+4Bz8D78=;
        b=tAfZcyOwBItdggBzg6NQbARJ9HYnRVdiUti1t8c9ZXw2V05PQKwLyCe/peCsHsoiIK
         WOxN4/sAofKfq/bK0fONnyU8DYSR0jeq5E3T8zQ/r+kiIfDUOKIz98gei0MC2KA68V6z
         DJGy+W0UkTGOgSlHta8ThPKZOhKtc+FQihmc1Ooq+TBR+ngdGfkjWY3k+3efKQsz3QHu
         s/EiM1iFi8/KInYSMtyUQXKyi1x9e8QopmYagPly2vWcDQ5KuPVUW8kX0oVOLW22GVfJ
         74UlIVFjT7hH0yo/ovYBcOlXvf5DbsyqtBPvGWAihelHFaqyyiNdaXsvbL4rpfwSno9V
         KWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789690808; x=1790295608;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rwBdK1wXdhnqC5rqC+CqcOIhT5t7NUEXcdV+4Bz8D78=;
        b=k8vqs7Jd2oZ4CdxP7mUf6+LlDlKk/kqVFohhMPR94CmuEyin4q2wg62kCYi4tJvBIE
         XMWkVcBDn6Yqdfl97IhXAV85eOU+j75KrVVs5aHVk95A9VCY0rJlfTFzez/aRalhoFeH
         HGuD95TDtxj6jR32pZEpO2qmEETIy7ZbnoDijmphubh0chl+pylPT8OJ6H+OQJPrzKWV
         wO0LNTNQfZ+ZjlMjeWV01Xw8y83UxAbEyhMe0AVua6CAx3obzTwr9ofJiAPJesPM6sBU
         NFwgKB/pi83DzItftK3zN9IqvYp8ZYP59NOIOQnUSLRRuaJxajp61DLR/6LFPJNs1a7b
         leaw==
X-Gm-Message-State: AFuF++mzSGvyBwcZm60ZgriRO3lDjugzQqlGnT+/pEou3DcVkLPWzAc+
	LSZvBYpVYrylhx6R1vUJreNWN7Y1io44ca1s/bO+9bySoGY/vj2i7fdozFlrAJ+DpMO5Mg0QWFw
	v+uXnTI9oAmgRMFw7SU0nUpIL+V4Y1pA=
X-Gm-Gg: AYBFou1Wt4EUIi7dc9aEnuziyrV0oXFQ599ocTkdpX0pcKrg0vQanZkrZFxecgPQuY6
	e7/PyRoDjuvYzWc8trQk92jXylnEeCfRHk6uGmbqWNh+lJ0Wp+x/9TXiETGPHdnMBDairlfGS10
	9Y3qj7KZ97/90ULGABZa3DG/6Cqimcc292puqd3+nS8TYReRMt7ePRmmQqTQtR+UJHHEutOrYks
	EwFB7gqJOfZTHNzmFfmd8W06zbvUh8ukhF1TXa2gD2YmzN1MNH5OEmnma4OhxvwhDQ8L6xRoQKa
	tVrxRSTgJkD/ljS4btNjsVbQGS1LEciyoTthQ50AZbDSS1Ejj3GJHBKYN+IkvbMxVPMS/BoGXGo
	yjM1b84BvuAs=
X-Received: by 2002:a5d:5f86:0:b0:487:a9f:4fa5 with SMTP id
 ffacd0b85a97d-4871e20f7camr1383464f8f.4.1789690807767; Thu, 17 Sep 2026
 17:20:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <CAKEwX=PEEkYiNRaVhCuM4E6mxB9huPKfkDa4m62VMTzedg1oYw@mail.gmail.com>
In-Reply-To: <CAKEwX=PEEkYiNRaVhCuM4E6mxB9huPKfkDa4m62VMTzedg1oYw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 17 Sep 2026 17:19:56 -0700
X-Gm-Features: AcwNN1WwGWSKeL4q_hpowjvaJHMaKB7C_L0Qi5i5SPZVgY5rRA1xq7ll_vyvmyo
Message-ID: <CAKEwX=Nuc1JyP32pXAScyOihL4nPz6qLpma9ZB6hb5Uxzs6XwA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4FB25C0003
X-Rspam-User: 
X-Stat-Signature: qw91prarje7ahibc36iurc5tg8iya1o7
X-HE-Tag: 1789690809-883921
X-HE-Meta: U2FsdGVkX1+Ow0BSnkXXTW6x729lWcjFnhwuNa1DVg2IX4mFFBopnL1U03j3SsWOU5JhGNmLIOOG7dYvlKn2YOXyfnNmw5qZGRBveJcYuMnd8EO4QgcYmmN5HowWrTjgQpFeI8PY2RrUAxkqkeSKZw9WhKQtHg3mxFB/Ck3bsFHoWGXADfBo2wa52/113sTS3pOXSM2Q94glX1XOrX0j/uDvN/j33d4T++mt+3wOHgVfOY7t40yEQ+CIYSRGj1CVV/j6DDylxZfg76M0jj13b+68MlOZZ+EA/hFebAUar381oXVSrow55oihbAYJGr8MYehliAo8m1r85LMcf8x7gLpJtXN1KFDqsbljfiOXNblQNvpg50F+QvdGdxCB7edjBUb0Y7rSrxoAFb0v3FCtVRaiG5pZerY8fna+IcdTpScufR7B3F+kfA7ZgN+zQutRH627SAPmWlTaJWJJ9hWtqaZ4KvHBOD7RIGVVEVuNHMfQ1Zr18bSgUD5J6Tu6qLRJE198hrN920pajgPlrE9pTo71iQksmdjDOKfJHhAvyW2zvk2YgSCBQrRMO4oUqKDE/L7G24fyIB9IOkFIaHiykLHGHdDpX/GOV2ZnKg6bx3RUyh5dMxESFxERgHcYG/CJaQCacbWlqL+NjNtxy7Ycb3AbrEgLVaDWnLDoQatno2yjHxMa+A6vd6ZB/cVuG48Dns6uDdvnvrHumbkocVnC/QAECqVoUs/r8u+D3NGQPkerKalLhiydL0K/wXUdrjxCu/1wNVFRrkrN2v4vw2UzXbU68MLxSLyntTEzLGtwrc9Dt1k2rC6PAaXqYgEXv+zDEIngYtgd+wM/52oy5jp++hopkUa875Z7ORp2f2ralnYO6I2qxgbxOQlCXwU9Jnz9MVvzBf9skSirZ+T/1+8DVL4DVNGrDpAYzPW2jWnKqCId1sAek+TTQvwIqcFKPxTP08Cr4tPwwjDbp02Njzx
 P9alqFRM
 x27kdsCNUeU/taP8xN2SAgDOfxcDEi1grqq+oXqQGl1XCy+LdhtpTJx2BfWWfSilBfZyyPx6o5lVha+qZmFSyB9OJ7j994xfxKQHYbIjQNAxP5MrCT5wqsJ0GxDCJbbXMD6Htsncytg/uoBXr8tlZXNE6ctd/FAzDbveLvrjan24CG3Zvfk0fYLmzha5ToibycWWYyoxDAtVKbSTuVNYB/D33zQzkCgCmVeal7RObsXMfRx4eiMG+fFbn3tp/M0nB7qED1t6xOA9DJr6r2MVWa2m+gNBibCW18DXsbe2NmUty933i668eFXTfw++0HJ2IZyTPGO2oS036UofZa4Tfjrti1FdvtwOX/8QqMD90UlHiwg8obtPqkN+w4mDhEIYHicCcqLyXlfrySmXD9ANlsGEWfrvOvA+6kj6GKrDGHjbzz7qdZCdTMjCrA1PHFvrMp2eSD7ZcFtugAfExf5N/1a+QUngkqvJl0uoKiStpPEXut21cynd4iEW169QQF+uamUzBioP8GHqbVH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 5:13=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> The other way you can get around it is checking if the folio being
> reclaimed belongs to a cgroup that allows for disk swap or zswap, and
> bypass xswap/vswap if so. But that brings me to my next point: since

s/if so/if the cgroup does not allow for zswap

(in case it was confusing).

