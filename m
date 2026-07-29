Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C63C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 04:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489426B008C; Wed, 29 Jul 2026 00:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A486B0092; Wed, 29 Jul 2026 00:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328B66B0093; Wed, 29 Jul 2026 00:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF9026B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:47:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6913940514
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:47:13 +0000 (UTC)
X-FDA: 85040579946.13.EB77E04
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C7CEC0009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:47:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yy22nrhB;
	spf=pass (imf28.hostedemail.com: domain of richardycc@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785300431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsOxAaICddqQ3S+W5WfBVhtklSa2LJ8zsYhmkMgFfn4=;
	b=4X4umX8pyDcsfDYb58aVxbbK2I3m5e66zyYJys0QmEQrdA56AR5wacs462+lBT8kVLnCYi
	Z4ly9xPqJvHqQ49ROUkhbpinRUQboXEDlapYd2558kjFdJudtCrg1Pa+qc1XHuJUtTBcxH
	6J3S2Q24FZV4uqkBRA+0DM6W2FQKHxY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785300431;
	b=Bz1Rf8JaF+6qS/Wm/llopfL/X2MOvpXQMR59DAtE4qBlxOwARRYSeBO42z50s1kdSe/Zc2
	/bsJ+DJJV+DTOD4ax67iDYRPMl3Cyap16mdvz4NRRArLib1ZmewMuOdcdHnQcbJe+UZjb3
	To1oYYPcp3osLrj/3IMGLEAfv04nA8k=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yy22nrhB;
	spf=pass (imf28.hostedemail.com: domain of richardycc@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b2a8173142so2862e87.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:47:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785300430; cv=none;
        d=google.com; s=arc-20260327;
        b=M/AtdcED7YhlNhEEWnUN7cwxFoJQW9Tf8zNc2xYXu+X8qZLp9sCNaD2EJnS5e7SE4u
         peX7tihhCFmDro/3uMuKhgaXNs+//bs+ZCzzj+IGjvRlilkrub/0LlyDgajeLEPLf6Qv
         WhT2z0SO7CDnxmR20CC7T4qbZYGgUPW5TsFV7s84aDxJnYtDIzufLGSO+rZksMxeSJgM
         wBWVJKkjmY9YVIJ+aCNHopsFAcbNWg2FL56XBWCJJ1BvvCDz8bfS4fqJ+nJR3Rhpu/XC
         iApptfD+ZiRoPrGmzpcQ4XiTTtr9WQcGJwXFxo4baCKrpjnyZj6U1n46ddpkKaDoESun
         5CCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SsOxAaICddqQ3S+W5WfBVhtklSa2LJ8zsYhmkMgFfn4=;
        fh=ANKMllm/n0u5flgZgITAZuzu+DiL1rmrJDDzI43k+5Y=;
        b=eB4ZbQQJ+2oxrqoDdd3sQXNyRFdlWif1Shh4KTK4B0LuU9yLQFV/pM9v9b9nZ2db7y
         Wkw0XMXVyantA23NTP1EKWyrc+mtG7sFpmpaUESFmQXqIjFV7TdnxPf8ZgeU9Zd9DyoU
         tsRgfjB95vErsSLYHiTpNBox2DVN5Ak0oJtWTt60PL6N69ohSeDt0f93zytHsR9II0BO
         0cY27eZlB0rqE9ldqBvvReLv6fzrkVUFsHVu7kIMF6iFqcIqrB+o4vMU2GQRXkQzoKRw
         ViQqXL5ARgKTjD+Qy6HWzx2ITeUxA3Fhy+RTr+PC/ztTB2ZMb7vH4eryRQ0//Qrydl6z
         V5DA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785300430; x=1785905230; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SsOxAaICddqQ3S+W5WfBVhtklSa2LJ8zsYhmkMgFfn4=;
        b=Yy22nrhBejJ3PPVWMDxsnmOY6IyXOVdeVlU3ecXzAqH8b/5kd90lxRLf7iOnDDiFzh
         asg2DJcHJUWIvNdghNPMM0d4wuTv+ErPfImN3SbTu8F2bkQ5suhUEzsMxdw/vBx4vLmP
         gLuxvJJU+2D8Q0iNNCM2xeWp5DoJDWbl1Pnd9wqcVE+DTfo/jfJQEeeXDiGpieZpb7X2
         2SVYFJZMsHjDePNm2kUvkFwV1JmeFGOOSHecWntUXgZDIlYIQ/1xjMWyypFGrxvMaKmr
         vAAoalk3edEPku2PXHvsq2tPkDXncKUMd4Z2lHwlRmSePvvrVnfnN6RzB8130QExHFtO
         WxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785300430; x=1785905230;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SsOxAaICddqQ3S+W5WfBVhtklSa2LJ8zsYhmkMgFfn4=;
        b=pnrFr0rzEUlxWGkNgxqwdrQTUdAGx2HWbfR/HpskoPdnDCytzD5r17hgF//fvQuqIB
         dKbtMJKhnU6zD3F7uggjSoeYCz2CGxS0I7EB9mjQeKnHzzwpzRQ2d+SMP1WV/wGm962T
         Tk2YjcyTtClGlSIB7zKe5UdUhezPL4cFzs/nesKgmuiA6I9ZbpbrFtUUF6yNr8jbQWNq
         Cx9T/IFlY+VfadebfpDRmqm/dMZpypgH0ZJqAnWMWiSIjSzIF09Ykb6770lLFPRwcLMv
         kt7b6T05c5+P2ab2LYO6W64JGlX3PoUdNfkgGeOKEQD+PANHfbtIDUVqPUpvD1bbbWso
         gLZw==
X-Forwarded-Encrypted: i=1; AHgh+Rrf0Qm5wzl886rJD2YxexWqMVk/G/gzXEGvc8imJ8pGxca5uUuzXINrJxGlcHOfwBgjy3pGntX05A==@kvack.org
X-Gm-Message-State: AOJu0YyN1VJn7TS0vKPr0MyDHKI5VPInaF1Fc7guTj/KWHqsWc6GGO8T
	A2aHRbBu3XF1TUIHZ9I8IHxI/Z31jyoxXzGn9I/Ns0YPQSevUX+K1dFjDGsGGquDqc7Q92M/Ra+
	OrwcXKVXB5GVbQOM591U3WUnzfYki6VwusRarj40=
X-Gm-Gg: AR+sD11VZ4Xs9Cet0gueVQ79GEdY1WuotUHvcVZ2hbaAG/P1bzzM+hwBQDucWC1YnM2
	a6M9Jngh9oox+dOQR9wpj2HQKgCV1J9H8kA1d/rpNVnaLfaJ+n7BcfeDjszn0AqK7i+3XSXyBpI
	EeXb88iz614aD9q4VrmXkuHt8aQ/7cGdY0hHXw1D1GB0ljXZnjR05SrDO0H8Oe9QCZzbBjG3Xp+
	WL7DE/fw+MQKG9ejjX1kSVATo+32MehRBxP+zKwMLt6kjnsrCq4NFw8sfaOFEseulK+UnlYrwCS
	Nhf27veK95QimBMioOIJs3wGOyp6verbRnqdg9aEFTdS7XB1UgBG8AW5XHfoCz4EbxQsAhD9+mr
	trw==
X-Received: by 2002:a05:6512:b9e:b0:5ae:b9c5:f29f with SMTP id
 2adb3069b0e04-5b2d823eb5dmr36261e87.2.1785300429328; Tue, 28 Jul 2026
 21:47:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260728055333.421080-1-richardycc@google.com> <20260728111509.7662e385aea0b055d2066e1f@linux-foundation.org>
In-Reply-To: <20260728111509.7662e385aea0b055d2066e1f@linux-foundation.org>
From: Richard Chang <richardycc@google.com>
Date: Wed, 29 Jul 2026 12:46:57 +0800
X-Gm-Features: AUfX_mzbNhZgHf7zB7CGs2fIBvT_PpZvadEE6_PKFpMwkIabl23wyjgy3d5Cl8E
Message-ID: <CALC_0q-RwrfxiMypoKRQWUkUzRwkt2KoXN_GbWLxXX+4xx0WPA@mail.gmail.com>
Subject: Re: [PATCH] mm/zsmalloc: fix release order of locks in zs_page_migrate()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Martin Liu <liumartin@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C7CEC0009
X-Stat-Signature: prdtykihgxfdi5c575wjsxanfc7z5nhj
X-Rspam-User: 
X-HE-Tag: 1785300431-660824
X-HE-Meta: U2FsdGVkX1985ALYfTeBusNWdivEmqDF9F3SG0/SJVGdc06HjWTmJJ+k9CcRHtfP7Ji+cOy95tcv2Ion703yPCkuyNtxol81CJ/SzFW7P2o2/Zak9y8eg8YhUrWaHRxTRn611aFeu7bk2WtFMpYzRKuImkUyqz5oNRX4QGoU6B6FuDrXOLV03NEZNHg/f9P3Tte67v+RypYxIjIsDlFFTjeIGfGb2MuZqAd3kTxlCaJpuBWLYdP0AH2hnc/1hD9JLheyrnbfOfdqjtvI3pvOKEjg8i4X4yl0fA1b0m6LGvL5xlDI1ulWeswic84AF//fTsdxvhwHrlTc4hTtq/OukUIKt8QW07cyr5jSLxf4yEbpjSgrRup5Mc01IqgwBVWXR24hoMqwSbE7jFgXYDYkj+KQ9gPR+qdL13f9OsnfWcJcr+RKgxetYFUaEQc++AsOhkvHG3geCKtawJ12TSCnFNy60AlEZua5COP2wt0twIJjMhor/QXBynAwKEWFy91rdEY+SiXqYGLqE3iMzp7WMUsg737FXaNjLRzjfhDOzADG6o4Wc7IH4BEa/Mv4wbBsJMafTXId9fcXKBSR6aKiwOumsXmghjWXQMRYEfkdhMnurYftfYT6TcAnzUmw7auynWCp6PQsGHfUiwvuUIg/Grlo5yQyGnGJG5BEoXA1IlM26M3KTfENet/qn1z6bUHXGx+swCKdSLVXcUIK/KxLaWTn3l+0fWqDNw8CBVZ/lKQwCar8iKrOY2o5RzKLe1bLI2RWB3qQOzZLaXwsZcpGu6+XWyWI0ysLfR4R1RXVdIzZ2tE2TaY/g1WJ0J+zphICSYZ8/qYKH16GlAeJ/6uF1pUFEQRLIATGfTECUqA8uhFtj9/CfE1MQY37hbicAJO8FfoNkK6tweiq6KPgka7adpUvUtrk4WP/Mj04JEUpPFNCYqQgZl4zzKTOklpOMat4SayBFdR/Pwa1PKkNbPZ
 CknJe7Hb
 B4pkXFcl9cTatJWY1YBxwqWahWDYdEPZL0A1tYVsJS321B9477m5fmOr0Gcpp3mRutEHfW+olKtfL0bR75j+Pu6USWo0rQ46vYQ+gid+24Ot2p0zZp8uGAKUbnQFa/5R3fdJ/slfdIVHmSYVrGoh9bKPVmlkRfIlqxooT7z1qqIuMo/92PhVA/HaOg5xwv/ZPFU9P3G0G8FBjKJdbCAhVI7Z3mahxPcO3L3fctf5FfvsZilp7oupebqC21Y7YrHFn2bY3j0/N/kmFmmT2fk1B5T+rgck+CrDAzkFe1apXD/k+Ywl4FSUtUbL7whEtszAZFhg6wKSmbKaVtOPRxwq4IRSr6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Wed, Jul 29, 2026 at 2:15=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> Thanks.
>
> Does this actually fix a lockdep splat?  If so, is a link available?
>

No, this does not fix an active lockdep splat or a reported runtime deadloc=
k.
It is just a code hygiene to release locks in LIFO order.

