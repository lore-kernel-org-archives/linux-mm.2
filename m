Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A54410F92E3
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5216B0098; Tue, 31 Mar 2026 12:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785C36B0099; Tue, 31 Mar 2026 12:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674D86B009B; Tue, 31 Mar 2026 12:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5146E6B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:36:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD1E1E0309
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:36:30 +0000 (UTC)
X-FDA: 84606911340.05.95E1F9F
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id BA05A100005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:36:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="C/vYp2mi";
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774974988; a=rsa-sha256;
	cv=pass;
	b=XwNBdA5A6Bzsuoj7DzWKQnAXQnwNwm/HCXRdexBuDi35T40MfP4wbeYlYTp08BVO0maCKT
	gmlXoTQbTYpd6AyE+LrDmMoizrSeRH5OA04FpqSuboekFrDsVsCEkgiOkxVQkVYBhN0sZt
	htMrjDq7+U+YvmQrZJPQ/1BjJ9nV7YA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="C/vYp2mi";
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774974988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWSOptAE86+nk6rmIBZP4eVP9NKvN58aD+FkvuVdWeU=;
	b=sceFg00tIUlecIPdU7JjIQobnT7m0nTAKCgjgVnIljwYVJIFvavQbFc2EEaoiVTZWXXuOq
	3V21hS/2AUwTMznmySzQnxMtCMbxOGwFmSPkl8bvwQtA/mT/sGdt2KYjafW076JqhEPvGH
	6mO1QLhe43sAmAiU+CqYzuzP2CuE6rY=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-66ad907833dso10257836a12.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:36:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774974987; cv=none;
        d=google.com; s=arc-20240605;
        b=Otfj7K5f/fH4ps+M1JeALIS69+Lgf1c/1CDIPLyZ0hV6PiQBZi4ecJaDEF6Vl8oTni
         2T/sL+nr6GsxBRAYY5zkz/LmWRyCfyIVTvk8iTcGM8xVVjltyazMHHtMXdYOoH7SCvg2
         TNqLZILKT16lyCLLPkK5L+zMIMOJBjkJAg98XQKP+xS5EgujoPT4gVq5g0+/jRpdO4On
         JaEIRKqkkUpCMYOFaDvd+aiIgjpd73ATzQKe2QBsilcE6+wSHCgJiPt3ELhS8iJ+X+Vb
         YSutAOfCE1wDE5eJ1BKm+y5eWJza8r80iGj1c7c9RXoTgKELY9+DN3BmoEw0OqN9GNN6
         Skog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GWSOptAE86+nk6rmIBZP4eVP9NKvN58aD+FkvuVdWeU=;
        fh=ekjsWhylw16fPdlmFJNQo00seJBtd2Z1YletHscOVBU=;
        b=TFykHaL6eX0WYFYvdarO1DAl3AK52SINZ6i92c34p3lLlXx5N2TDl/38uRLahvtXSb
         W6az0iDIwSuSsdu3AWSpfBbRw+cw2nlON1sB5pimL1h03V7rNCyOmP3TIKq/zBf7O9ww
         MXwN0dfPNMv9YqrSWy/HKlij+R2K0rdd5n28DJpEQx/KPhhUUlktxWGV+0weprd5qIrR
         jd8A4AxVfYn2nonBF+xipjSkkh3d4TW8xDkTDqcWujR2O1mhUrnsivejh0K2moyyfycs
         OLIYmXWOyJfhsQ7Jr1v3+LEwSxj9hQz54gKEz0jUPHxGGzGndUKnIPDj/2RrYPWx3wie
         9ooQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774974987; x=1775579787; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWSOptAE86+nk6rmIBZP4eVP9NKvN58aD+FkvuVdWeU=;
        b=C/vYp2miNIaeQoLk9RhUPM0HUqgQie6VMSZvfs3b3scd3N2Ub48zq2+LPR9F0Wvu4C
         HTEuJ1hZuOT636y4CMj3oDuQyYOO+WsNxIFLylEnb7Pha1XCXkkKkLSIlrzWBvt1mMxK
         Zfj0+kEFNK0pOx/Tjs5C9GJKXzI6wOFspgyJe/bV8R/SstkCqVU9ZVhC7N6fW/dhbMrw
         yRnhFGwgttQ88BqAsRgHfbXcR5uibnrq4mTiByT6QB9+5z/qiKXD9jU5z+hfPM/yF5FD
         rjbteF2+k8kCxSJiEWIiB12K1d+jzdVYdb3bfs09ooHnDwtqMGajR5z6UCPCGkypogLx
         vkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774974987; x=1775579787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GWSOptAE86+nk6rmIBZP4eVP9NKvN58aD+FkvuVdWeU=;
        b=XIWLeHjRiPR2+0qUNdaiFQ81LCunntriz5PMVwWTYTdLwOtbaMNt8eqrdPEda28ugz
         vJHxw7sDdEJiKj2q7YWuubZmVR0aaQS3wQZOML7ZNbCawbx8GKNTabprrsM/lQpV6yXY
         AXTPN3P60u0VHdJvpZlHwOpYxkuxobQQTVlD3r6QzmbE1EAmOJmYXMOTbR9KkkqSs9rG
         xyCqkgH0g1B+WIpRxAv01neEqVlAQdd6+unNvWzGbk5lDQpbt9/xIjFNqyFcqCRho9Eh
         941sLeGpDijClEmmFrgTcXg/HTHtsQhpNpJIUep6sKnj/Qu3bvJ3VcsxXQSg/jOb9jT1
         FUOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyiM50Yvh23mlRR9DRPjs2pAmq2WSiV1Li/TzROZcHNn3go8xYsZIPod5FADGmVJaK3kjGzKZx/w==@kvack.org
X-Gm-Message-State: AOJu0YyaarjybMDYVlN32pvgSM14sgiZTrDQPgRbnLt+Rh+eBR96D1nl
	c0PhBL9zFAS1dhzmN+26XAAVLZOANxrvim8dE8M5LvdDq/tNfcUZeYrdQKcHn4IHOfTTia3XR5W
	h31+hdBf/7B/COpllKmgNO8iOkfmjwGsNfOPr/HQQow==
X-Gm-Gg: ATEYQzzEuLEH4hc264fg5HPDmjcT4+YMEwVyEH+V+tdBjFhCu2JRF3XMmhOFwWG4SaA
	2n9cddW5Vo5/MBPelW5lwsEWec8OwHBS0HUo+E4LCo2ViZ3DuKREEAluWs0hT4hJChDwpK4mjv2
	l391Spov+YvI0XkrrKc9wJomSsKOeJ6FV9CBTxAJ8raO6PQDJecrKMCtmbuyDd5Y1BkpB5wKARy
	4kJFqlJ9C9wV48XjKESZNBpUToTBr+upSuxVKaaRpNQ3ZkSxxunniyHWyaJwxZWEvayd/xyX++j
	2cJiBqJ63YurNB8l4+UNaJcNmSzoMAT666LLxQ==
X-Received: by 2002:a05:6402:5406:b0:66c:4b8a:8397 with SMTP id
 4fb4d7f45d1cf-66db01a9586mr140428a12.12.1774974986824; Tue, 31 Mar 2026
 09:36:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
 <20260327033335.696621-2-pasha.tatashin@soleen.com> <2vxzikaciays.fsf@kernel.org>
In-Reply-To: <2vxzikaciays.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 12:35:49 -0400
X-Gm-Features: AQROBzALf6nURBi01BoNLerbN-ShDp_hd-O12KcwXWEz5p63cAkjGzOyu_YQG2k
Message-ID: <CA+CK2bCnn-0WNU34LFte5+37jMOLELB1dXHkX6shO-3t3F3gUw@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] liveupdate: Safely print untrusted strings
To: Pratyush Yadav <pratyush@kernel.org>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BA05A100005
X-Stat-Signature: kruh8cwmc48ee563786emybru5m7rjkf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774974988-762945
X-HE-Meta: U2FsdGVkX1++hh5UZz+T/PrZ1TFW9o96BJgD7ZEJ0soHQmBiXLIvbygvxMOsay8WqfFxoxwh8SPS066Vhvv6dijBvZzgsnszT/0qucGAQcsCZRTftpEid22IxPdkjQXRlyKHHCjcwpkLG1BWg/giPn+2h+dUxz3beeNqtjRl0cT4q/fXse4B4RvW2RXhZU3wKzC9YUaR+RgbhLR8+V+5vnYQtHuJIAhNljkjZRqK1FBOPZ8t3Em/2xamyLNyFjBbXSQ0FwHtqPV6squixzENWSL7JYCoP+LRycoMs6i3wrOhdCwSAThk9GvgJLClxFpgwSi8i+lKfTR3+rjiOzGKI8In5F3F/mRPWeNoa4BoGDJ24szDdAsIWNfIiaoAtmmTNEkcPWRY8OLnq2JMRpSI4K0q6n8iI0VOleaMRoDPMr399SSNBGOF8loJ1DVm6CEt94zPC0iT0bcHt/3+6D9d6atmYBbOhhGH+dYqrjmU2X/tv2582UwAsx95Dl5l4K4yyzb6/ZRsAONM3hmeNPjdgRmLz60Oi+ubaZVwiPBd3OxPDunYEq+szB82ERkziroDPwHOK8xJKEogdyPl8Ss7HuKtChXWy7x+bg28NW4gGcXw0ITrGn3wPIYgTWAXwhXo8I/alLy3guZNWUBJ3jUHroQ8D5mz1ESd3nWVTDhTXkcVjUYSf3ZcTtbFFqNOq+QyRhZjZXfLrLCWC+W3ZI01/ceLRcTjrGiK9vHOWvfzONAtpUSStgh/LzlCTTv2Skl/E+3U4Hskp0S41uH/NHeKVC/30ml4McFdqR3cvt5KQCF9cA7r8wn4FwnKWRCVRIQoWDP08uMEkfBDdnaaVS/x2beBbxXtjqjKFurEsTUHp5cKGldwRmNEVm3v7cP++o4yMposPoJKcdgp2USV+4Tq0SiGfTeIiyrZjVHbGeY7N2J+XcB7AdmD6weej7ih6ffwS5Qn+Hv7LzkeZXffxMX
 PzJMI76B
 C06QXHrDI1qv/+lFP7MDs7pMHTopKRxLH/rJ7z4a/6X6mAW0cbNjQ5j8wkX+eXVBuMr7rkD5O/BpK52RxpiMg6w+4d5XY+UZLmONlJ0CRNIRSKQ0MYTnyL8O5DOFwDEvNaUDPh6n7t3FF3XIGZqwjYJ8Vb/wUfgx71izgKQpP4nb68mW8xoePGO0MViX/HFkez8TS5PmBZIWWI5KRpfwCAhVLYjkNDLccOd50jgcutn6KFvXjXmGMSV1szHqnW9mHWri6JHI/C4i+FKndIr1T+UjFIT4T9maSJ+9oSyFSiWz9JXijbhWkwo2hGu2LtbN6EANW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 5:50=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Fri, Mar 27 2026, Pasha Tatashin wrote:
>
> > Deserialized strings from KHO data (such as file handler compatible
> > strings and session names) are provided by the previous kernel and
> > might not be null-terminated if the data is corrupted or maliciously
> > crafted.
>
> Nit: KHO has absolutely no way to defend against maliciously crafted
> data. If the previous kernel is malicious, why would it try to play
> around with session strings when it can directly manipulate the
> serialization data structures and the memory they point to? There would
> be no way to detect or defend against those. I don't think KHO should
> even try to defend against malicious data. It should only care about
> corrupted data and bugs in the previous kernel.
>
> The only real way to safeguard against malicious kernels is to have some
> sort of chain of trust mechanism like kernel signing. That is of course
> out of scope for KHO.
>
> So please, if you do a v4, drop the "or maliciously crafted".

Makes sense, will do it if there is another version.

>
> The patch itself LGTM.
>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Thanks.

Pasha

>
> >
> > When printing these strings in error messages, use the %.*s format
> > specifier with the maximum buffer size to prevent out-of-bounds reads
> > into adjacent kernel memory.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> [...]
>
> --
> Regards,
> Pratyush Yadav

