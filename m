Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CAA107639C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952DC6B0005; Wed,  1 Apr 2026 14:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903F26B0089; Wed,  1 Apr 2026 14:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819796B008A; Wed,  1 Apr 2026 14:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDEB6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:58:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 031B2E01BA
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:58:44 +0000 (UTC)
X-FDA: 84610898610.19.F77BA52
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0B2E5A0012
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:58:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CSyuOJZn;
	spf=pass (imf25.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CSyuOJZn;
	spf=pass (imf25.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775069923; a=rsa-sha256;
	cv=pass;
	b=Yo4MK8mXY9Pb2cnTA0lkaflBSZoBMveI9S++vJODuGnVoxt08bE6IXkCMcR+jEsIco0WgT
	rD72T4SRho7E5wA8oaUeywhwgAcJsc3jJBy4FnEagcKwUPOIgxCVxZ1tXSP+REpIrLrQ20
	U27cL5EHo+1snpdpssmkh1gJATauQQQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775069923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuWf2GurnRCDVCOErqdamv05apNlqYHl34+PkEANN+0=;
	b=kwBvecLJj9kAf8+JdqBEUJrdawLdOtKayeE+eopz528L2fQfiwA4+gs3P9P517ojBOou/9
	Et9bA66DjQqOzRz79EuQBS+SmPrhgyMQ7VXHnaJ68KHNyeVblqPuYAIP/KR3e3LN66v/si
	kCW+koCZsO4yb/FXZEuCDMhRy5pfaxI=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66dd1b5bb6aso156280a12.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 11:58:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775069921; cv=none;
        d=google.com; s=arc-20240605;
        b=dGA56PlMP1nu9o+XjqaYQSljymqKsW2sT7xE7vpGk0BtnIhAvgb80J8QZSpH3e6APl
         ta0azStUvEgCOpnTgDab4O2/zGcYb9KzWGJiBRZ3IsWM8uNjaJB2ZwRtTBLmQGKEN/xo
         LVUk7vg4bAnNceoshmv0VQgm411L6KCIZ/xEqnG7P1j2FaHh5howkqkNEXtzpN/5SmW6
         lQwrkS4EcmqhQW3x4VaqadxcoviUOAIkwfoTuDHromLt/Mz2atU4S3dusa7SPwIfNZT8
         NMeqyvvDRw82e63Xw/Ulux2/2tpoZbxKdREbEb3wUa+MoFPqC2pqFJ0dwd9QzuUXOb+F
         h0tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uuWf2GurnRCDVCOErqdamv05apNlqYHl34+PkEANN+0=;
        fh=qv4NSRwFu3Lu9gKqrNOWGzfhll9UE5VJ9A67GweK594=;
        b=e53TrMC6FHhDQZKtiQfRBzkZJTkEizJG58YUckC1oE62fE/5CAqbojIy1usWIAk67a
         opyscMmUnvBhcvGoTSzxGzUXukAGi/3e18eh9DxznTzUG1X2dEN4T6Y9mrLY9Q5w7oha
         leo0OnQBkt2yY4Ms6HHft1TLPamLtnBKdn0lp6KXa73L5Ha9SRMVw6smOcCuc5LU/xqm
         rDBkE7Uq32DM/KYQUlInmLX0IszX7Mg/d+LvO0c4HjA6SQWSjWutgDp98Gb4h+GsFjGF
         eM4r/KBF8qtWR6SMnUB03peAneW6AfGQc8Dmls0ovglYbbwTNUdx0qSkIhIxgqLjwPPP
         p1LQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775069921; x=1775674721; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uuWf2GurnRCDVCOErqdamv05apNlqYHl34+PkEANN+0=;
        b=CSyuOJZnF2gda+nJ0ENZuFcMzJWJIIFzB3zXixpdFKBaLy0kwVdSwvHk1xzyLAvBJV
         LV+1A7jRbjVPERW0vhZ0lkXk4nT+2d0FsFRb2Y2rZIusG9ElCMDX62I7gbgzHFSJXCmA
         oVPZ/jFDp7bwiTfKVYaWyaGeKJBckQmGiNHqThEHTGAKMqNp+1MNxkD5qcONMVWH5nnv
         ClG96zLbiVHUMK0gblOWVQr4vAB5nP/ryYXGHVJxB/7/EnFJ02PSrffwn1PvEOJAU/cz
         f+Z9Qxz9+8igdc2j7/HIxSF5eMD1nG36QG/x1ObN+0BzOEBYP7IGEOKvcplkKxvpJH9U
         gyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775069921; x=1775674721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uuWf2GurnRCDVCOErqdamv05apNlqYHl34+PkEANN+0=;
        b=CgPk944PIxpXeah4iR/CFaf6oyRthE9QuLFWqOLOsoC1iOc9Qs3XJWQSV4V4NfkXFO
         OXcT9yP5zrda++ks7LoWm77gY2bO/rn8Wk1vaQ15yeibzb3GOPQAz37Zv1ErjtmZQHok
         G1lTtxypw5k7g6rXrt5SmM9uxG4pSngrCm1Hb3+BjKKEgr15SPfqNb8Qm6b85qh0q+Oa
         DPUP7PmgIWGDb9qmrBfZmChbmz6/rg8BdYuInTuWlXAapLXOM7MiZ0ok0tqpk41WywC0
         7iMPh5FeyxGAKp+h18kmosr1YKtAqkpFMRYEf1ji9VDaqHbLkO/4cvZUgYzqxgKUZCmk
         uuPg==
X-Gm-Message-State: AOJu0YzT1WtGGs1ZD7U1e0iEklbz0hr2Uz8tqjpkDA6UStP6zRPCs0nv
	GzfPuIbWrWtzzkcftzJCG3xTZY8zLMR1c4qBAAWkEvmOeIyJLD7nEwRQiZv2bS/EZ/oGcTSMJpG
	s3YWELNTV59kvxeZNMitO3ho0UjFlbpE=
X-Gm-Gg: ATEYQzxou+CHL+OjlyXZPr5bSmRafEGz+Emr7nASutfimT6URHoI8CyzTvs4S5OQxt1
	82jVzPkVxCIT3b4nLQdPL1Jm199NMA2oSghoMYQ5Uu9/C082sUf6pg7r6Uqv5kkl3IAZqc/xOrC
	CsaiJfYeXUvLDkBCoS5iEDWmjbOpc4ZkHybfqsEynJIARUBElmbxPQd0aj0fh6Xr7DO1WgBeQaA
	Sa95rvyCjQad9K3VQaj8Lds5FP7xilBn9u/mChRniyu557w8hO8pCO8LdTxw5IMyCgthhvz7Wx2
	o2E3v5+pm4i5qYJVaerLcaEJaAD+YW5lZ0OIzQg07moA91Ta1w==
X-Received: by 2002:a05:6402:400a:b0:669:ed35:e47e with SMTP id
 4fb4d7f45d1cf-66e03d9a862mr261663a12.6.1775069921323; Wed, 01 Apr 2026
 11:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260401131226.4011156-1-mjguzik@gmail.com> <ac1psq0rx_GOWyYi@home.goodmis.org>
In-Reply-To: <ac1psq0rx_GOWyYi@home.goodmis.org>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 1 Apr 2026 20:58:29 +0200
X-Gm-Features: AQROBzC231hOMt6txTY2UzjDGYuaqIOTN7ZqPtmG2YhQULpXGJ8GSWKeOIzqBpc
Message-ID: <CAGudoHEe6yYJX_qUsCk4EhWDQQuM_4c9resO5WRJ+yix-6=hPg@mail.gmail.com>
Subject: Re: [PATCH 2/1] execve: only smart people should use vim
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B2E5A0012
X-Stat-Signature: 1f4piibeuw49gsqs8s5ckcn475kjc45e
X-Rspam-User: 
X-HE-Tag: 1775069922-726587
X-HE-Meta: U2FsdGVkX1/j14IbHsKX0WX0UQs6T9fNFbCJbSNKE7T1CSOKHoDpldwHzdMUwLLBbZ3eAcD9yZinQnp5Yxbqi2EnQ0DOq+3GUZ5iDLMKN4Z+DdhDAnhcvkbZ9sjZkZ12AnuAX9+SWbunMRpG8eXbBZqXkRvKZts0Tkn/clqNFRaxnT0IQaTlgWsdA2hQRwIFNbqy24jpyu76Xv/mec6jk6ub42alE8Pgj8ArQ7LfGUkRH9IIrL5s7IZAPE1JcoLH/U3oTj92BdajQk/e7yG83Nq5vY9cmhvpnxi4/idKk/jUsObtjpptftLz0/H35nCei2RIBllOm2LNlf48RbsC3ZRAva5yPqTmt73hCegS6sYfsiCR8r3tiyzhpcJKPV3qL8P7F5yG6y0XnVGDHFkodpcXiSXcVGmIEqtJ8yZDENPto61kkuW+RpvzCqfvkrGvD7hR/5/U6Vh6s48A+6wuQjvKKa+7GupEfufX3H5IQo0D2YD/o4rKhq181xEwFJW83qKn3xZcXzykA3jqer+J7bsCH8Xa97OR0mH34uTDZtYlyUeIzTUiCUMrLOwcEJFqEgbCAhpdzndTkrI5GEiRrUM+4SxkdrB716qwaK2GkeXyyvfLEb2O0dNEQv3lQZU+0S9z4ZPWkc/n2QW4Y7gdeFoZ+c8qCs3CBT0ZdYl278UrcGoVGhRGnd8EG12I6bBnTt2atmIdndsxo4KMqADNyofkuquNQKnD4qp17tytzuYiUzS5+/EuJ6ZQJJQMvjiLu4NYBPIDYdvPR1ApAYdPWmhW+k4aIepulFG3PPOgbRmV1No7g0GJGhKxLN8TW5Cau/GRgWebDPBg/K5XPyoaHmyDBCdbcO8xywdmOlhmLdzmn1KPmkg4hems0/GQjhlTUzatrUVuD6/gJrbGNHQ7PPgJoQOQwNhRVBKF/+6q4bCSY4a3k39YopLl0ksbwfDFEWtU6zXVuVkU8Sfjjan
 U+o1zh6e
 w7DGgxnEfJZNCzcKWfg8wfAOYwAKJYnoX06hqrp/g8L6A4QdRbUH68icSbJiIwHi4ITN8VsAoteWQ2wkgk5T1rWcqh5qZqYQmKzog5O1L2AtmWxKr7JOfOt6zwOevawY/5f3JlMceCoEIe89nXq/o8dOtfzeeZc+3TYzyPxmEfZmzXg87wHIsWGRxSHDpOUP7SOb0PVmT3cAifC1tYuQin0co3HQUn0S/5UiG1ER7PxEAIUO5WIzXMj0wUkkRFmeE1jQNGg4pUwoED+1nQfyrVw3yAlYQphQZdr1brlgqMF2B55HSWYU9/VNJ+rbcWBn4YS1YcEF8a0dUvHppNs3V0vQTEYnTRaC+DN24HCrGRAFoErnZv4TdClJieJGXhRabZRaOXe0zd6uv5XiylU1mTkAY2aSLsskc50WZKcmo5sY0OAsWVyJEbmRYjAqLW6goX4IjcvXVOQ92yixMjmoxnrCvXArqaV0jlHgz7s5ezI7yP1jbATz9k5FVU/cI+3Hbq+2J2Ra+l6nAaZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 8:53=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org>=
 wrote:
>
> From: Steven Rostedt <rostedt@goodmis.org>
>
> To keep people from getting stuck in vim and not knowing how to exit it.
> Make running vim a bit more complex.
>
> They can go back and use emacs, of course that will fail too, but then
> they have something to work on.
>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  fs/exec.c                        | 11 +++++++++++
>  include/uapi/asm-generic/errno.h |  1 +
>  2 files changed, 12 insertions(+)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 2e954b31e3a2..ecb425388008 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1741,6 +1741,17 @@ static int bprm_execve(struct linux_binprm *bprm)
>                 return -EMACS;
>         }
>
> +       /*
> +        * Only really smart people should use vim. If they can't figure =
out
> +        * how to circumvent this, then they have no right using it!
> +        */
> +       if (strstr(bprm->filename, "vim")) {
> +               /*
> +                * Learn to code!
> +                */
> +               return -NOTEMACS;
> +       }
> +

I would consider extending this to nvim, otherwise looks good.

Reviewed-by: Mateusz Guzik <mjguzik@notobjecting.org>

>         retval =3D prepare_bprm_creds(bprm);
>         if (retval)
>                 return retval;
> diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/=
errno.h
> index 1a8fda40cd8a..4cc4ae653cec 100644
> --- a/include/uapi/asm-generic/errno.h
> +++ b/include/uapi/asm-generic/errno.h
> @@ -123,5 +123,6 @@
>  #define EHWPOISON      133     /* Memory page has hardware error */
>
>  #define EMACS          134     /* Editor too big */
> +#define NOTEMACS       135     /* Editor used by smart people */
>
>  #endif
> --
> 2.51.0
>

