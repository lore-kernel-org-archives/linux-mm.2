Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56327CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B063D8E006D; Wed, 17 Sep 2025 16:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADD8D8E006B; Wed, 17 Sep 2025 16:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC678E006D; Wed, 17 Sep 2025 16:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84A4E8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:33:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26A5486EBA
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:33:10 +0000 (UTC)
X-FDA: 83899891740.27.A83F44E
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id CFEE7A0011
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:33:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NVget37V;
	spf=pass (imf25.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758141188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2/zE+U2NdiGVEzz6yPQL135dw9YRWvNuaGSRy0m5PM=;
	b=UfNi2QmoD9tb3ccLEq155UFIQ3I7VBIDNql2PZLrP/JEjpTqstUVXoR6FSteHy6BrE2Ydh
	WxE3NCqy5PqRWFfNkEm51ATP/mbVpf75UIPGbzKJFfrb+JsjT1p4hympON1yiY2EafMJXj
	Ggs7qfQD84+N+hoYpZ4haKq1EJ57EAI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NVget37V;
	spf=pass (imf25.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758141188; a=rsa-sha256;
	cv=none;
	b=gGk1sx85AYj2kKyYZ+S9TRrHw5IMNiZQ9o+yqP3dlFQMtkDbvqCxbBsAeUfcXW9ZBdUs2v
	NFfAcQ/UzJBvAA8ZtZu/M9IkGMY76g+5PYK0OeMD+ycxkopldb0PfzFtv13qkEx06k6USb
	P8KypaeEFgFxUGotmhUfSdUec4rotb8=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b07d01fd4fbso34433966b.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758141186; x=1758745986; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2/zE+U2NdiGVEzz6yPQL135dw9YRWvNuaGSRy0m5PM=;
        b=NVget37VKekg8al5NUMh0nZEHwLqBtDo35SybIIVKCzWniSVkvBrvJrgqltCx0McEV
         AYShVYeNzCljRuAemihq2rVD4YWRfdm16tYw85ZlihRedbXosroOYA8xzN3SYICPRcrF
         MiUw3c53LzRgaZC4UVBrSc4m6DxIDTFuYsecY0rrXE7k/4+ps+XD2jT5etXlRn00/Cp8
         xbqoGNjt64+lWj4W+9BwCCFlZR/QRXD0HH0v3+cIbcQmudtnLphbHQwl0JpFv9xr9Cc2
         uRCjIJNvLkUXBji91x0Tsa7ng7ufbRVbzR/52X3wtGU/zVcN+00C3wK9yNrQZLqzZUEE
         CTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758141186; x=1758745986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A2/zE+U2NdiGVEzz6yPQL135dw9YRWvNuaGSRy0m5PM=;
        b=gObokNJJQGNXbiuRsVlvR4AXGs/139YDzS9zLNihhJYeolUqgabCLtOlKag1qxohTJ
         1FEOYJSmIRfWJSYKsIBsknhTrsjyQ92avGETOns8Xq7eaBFVNrQR79LR0RQZ46rD8prv
         OliH7kC/uP/tinR08WUb5NHVXa9SnTVC0ALGPrwJumJMjbByXch/7MvMtAFrMKwbXaap
         Q2fG2A4aURvg19HusWlFaj6ozJ0hZESAhkJon/Tzakju2PZbTWaSloddQnp0CI0btMxR
         BGz81YyCKfuYm5NfLE2S5vMAOQqkBQDO+17YpsAVPOu69YlbWLnpQNJC+VAFU77KmzYf
         EhJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQd+XZjlkOnJf82Aaidfm92B058C6RhsPWdi+GNrgKpMTIrgEd6F2pJZqeBsKiOWoLbzM78+bjxQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7BaxMxIZZAVV3RkqED6gBXhKP7cQjKtFeyBJGRa5KGgGaerVE
	6+1n/RCgHz85B153Q6HS1Y9+bL19h/AIWDbjc3ZJSApXb/VgYl6ODlrG4rpOD7Ps7LX3vet9Ec7
	yH8fxvHtHfZFOtUIwi1gzOvGZ0D5c5TayovUTVwtKCQ==
X-Gm-Gg: ASbGnctKxd9BwjQwx1HbPJfUiourDUB6dY2i/Lp+eEfaqlU78dQbvAQTOvnndHKOx+f
	uwKFOYBfzDByf4kiUMHe6rKyCJNtexZ7NlXUYkuO7O0xECoShQ2e+E3Zaur33d2pg8t348Mudil
	y+orwApip/euyzByvhKngJluzzAk4FPD/a0JJD6jmXnxeRMupY0T6lbcvt/tajuDwwnYsVpCh1k
	USUXRL5gWWAtcThprHtt8rC5+lIhUOCYlzwBTw+a2beJnvvosVHRgU=
X-Google-Smtp-Source: AGHT+IH9oujhhWDrl44RnWA34Ua+LIz3ygyCfay2po5pFCbVcM1XbntfX9EHMI/yw132NXrBxBGW0Ue38XZA/MmI8QY=
X-Received: by 2002:a17:907:3f9d:b0:b04:2d6c:551 with SMTP id
 a640c23a62f3a-b1bbbe51362mr375134166b.42.1758141186331; Wed, 17 Sep 2025
 13:33:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAKPOu+_WNgA=8jUa5BiB0_3c+4EoKJdoh9S-tCEuz=3o0WpsiA@mail.gmail.com>
 <20250917202914.GZ39973@ZenIV>
In-Reply-To: <20250917202914.GZ39973@ZenIV>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 22:32:55 +0200
X-Gm-Features: AS18NWCqxCzXv8eyHW2GR-MxYUrgmiPK3CG9A2laulzc4bLaAxYR1-YXcuok9Go
Message-ID: <CAKPOu+_KWSAHF+U9UFrON3nugt9mQQcwCifCNbBxkKQUEnFF6g@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CFEE7A0011
X-Stat-Signature: zmqiia5a71x38pxaqmc899dfaryjyocb
X-HE-Tag: 1758141187-944262
X-HE-Meta: U2FsdGVkX18LXJfjA5tGXQCxdnQWowQL3QbrgJLMGvgNHaSczE0WJhl33OzWciPC2Gn+EJYWDl3f8RZwOHWLKD3o9t1ZhD4Pi9eGuFHL4RJG/mD4SMvLfkfr+iLb1NEzgtyY+nCm/Ras2j1oIl95hvV7JiI0LbzPrblQLocZPyq9+i8BCVecz+n250Km7V7WbbmwSls145gXDHKhHkaJyzYlsxou1Sv0HqMKq8rsJNGORBbqg/zCYsGL87HXUEXvNTc8t3ed0HGi1XUHBnlRPiNF37BVMaoAIWiHJtYx8kfL8ycOKzKDzRZrlwbE+5nQVd+tAgovz3Gtoj+O/cGrRone7XPzRMDbKyV194fidqGjSIb8WcAepjRmoUCa8izlleOcGPQGQK9VXKcdUDkls5IM+sxv+luFsQtHwKxb9Z6SdLQcazmXHdtYf9+imjFZraRL2AYAB6rUkadQmNSy5SY+q33N+WUxg4Jm47GFigJWmpDXPZQo+ZkGy6U1gq2vkc6GPOaAqpSugK6zbvtZvlwdvDPsGQ2xyp147WHbi8KxBz4Kw1E3YqPqs2km8SrpehcRPc/OvtCox9/Szf+h5pfp1lKRHXDyDcyvdCkPZtziCHCJj9IGjN2WUhfwLJiFF6V+hBvZWLsC63Oq2wPDGTLgpHtrcjGek4uEKjtv2XZVzeKuwK+aVH/GNs+DAQlvTWHBUYbDigRaJf1QWpU8kw6V3exucsJbI5lRfrW9kBN7pr/hIyEnUCV6KGwd5hdZzTQSebreTQl6axxAsdPtIouiVgErHUwhAIOYiXBA+CrW1wQpqnoZsNRC9PWffeO/Kys1Rz1nWSkydIcxdTDPwI+kwQnAxKNAvco7sq0Nll+pF03a83GExDci3vr8uVTXnFATbxws/t76+r+0GJcw+Krdp341WZAiXVvNGNuU3P9YwAK5pLct2cIJ8lexG3qX4cJKVMl0/sBG6COBsib
 ECqbo1gi
 l9oJFzzDvWMKx2BtKqN2gtnNZ0TV7VNaD55BoqSrXrhvwRmXQkUQ1syUubrt8hJbTA+To+wqg9mPwMFDe1bCki/xkc8bkk1S8Y2aOSPlBPMEnGOyPXxBH/ITpablQaAUvaMuCEOspziRiXk3Z99OTkQYlebUnrX+6luAlIRTHEGShV41jyup/H+0tt3kNAIH6hv1U60PAjk8vcN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:29=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> At some point ->kill_sb() will call generic_shutdown_super() (in case of =
ceph
> that's done via kill_anon_super()), where we get to evict_inodes().  Any
> busy inode at that point is a bad problem...

And before that, Ceph will call flush_fs_workqueues().

But again: if this were wrong, would this be a new bug in my patch, or
would this be an old existing bug? Knowing this is important for me to
understand the nature of the (potential) problem you're raising.

