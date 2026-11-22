Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CE2606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Qxn6uF98
Received: by kanga.kvack.org (Postfix)
	id 3DA2E6B05B3; Sun, 22 Nov 2026 10:08:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B956B05B4; Sun, 22 Nov 2026 10:08:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1FA6B05B5; Sun, 22 Nov 2026 10:08:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 062016B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:08:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F5FEA0744
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:08:43 +0000 (UTC)
X-FDA: 85463086926.05.1AE99EA
Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	by imf24.hostedemail.com (Postfix) with ESMTP id 53EC7180006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:08:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Qxn6uF98;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795360121;
	b=4JR4o1jf8q4BbjjHQxuz0I0uKxJ/MluHu1XMAr5Mr61wx8I5F+J7+IPL82SrzbbQ5qcXdm
	ipwdatWdte7qUVFmPp0G52FPOFk+b/vrQ5mqiQ/2hE/0HKbTha7jX7cTwxiydIm3IXyDgs
	g/n5TADZ0gkWn7Ttdbe1oI1oBHlILAk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795360121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgthaxTJeqjgkIgsu2LWRipxKF3WuNFf5m2ROqkfnrk=;
	b=yR9ijUdW81iOXjnpbnNdBqi+yJ2RMjO742JsRxm0sQukG1cXcw7S5qdKA9dR6Q761EZFRo
	envj0B2r3c7GGbVfOJyFdxbQPbPDZykYZvH8Rlpbd8k5SlbWsgUSzV13M3n5ljRFXeFEny
	te4XGCgeCjx+xG4DAXLHSxTb6tYbFZE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Qxn6uF98;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi2-f9.google.com with SMTP id 5614622812f47-574d803e863so1055053b6e.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:08:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795360120; cv=none;
        d=google.com; s=arc-20260327;
        b=lNUv0IhVdlep8dCFGqt+72DYvDrmfJLKeQeP3RH3+ERxJmC8lzRa0+zvERW5hFYqn/
         qsxdApcVsVslN6AYZte7WsD14cezO5F/FlootH1Ve0RyRwS58hevANpp/QYE2NmZ7RX6
         J09CYavW+2TApYQvm/yEAtVKFnNHUOjaDyOc+3AWk7CIf/90Z9FVdjXMgCeEQHS2H4Un
         G2koACRZZHjSHtRhvMhGIv9mfRpQ86a8FnUJlwFa4AlxJhwxarDFV8CCpCHRFFwAYdHt
         tM2Q89Z9UQVYpP8JfMHUp9LDIY55fnJLmMDR40IfjqZPhzqdpQOYpv+kYl6KiHXaV5qa
         BgNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IgthaxTJeqjgkIgsu2LWRipxKF3WuNFf5m2ROqkfnrk=;
        fh=1Ff5YEHMhQxedce/OYoUrz32caz7JSME4rI5Hh6wiC8=;
        b=eOK1B8eUYuEC+lToFId1DK3qEvMm0asoPa75obBlRzDylj5LIC+z0jksYTJ3CY+9ZW
         hTCMd7Vgd792AC8lDolRKjXXxkiG66F+9drSANIizDwxVnBvfrWCczV1F6NcN7F9c790
         1Kak3ByNHsVpPVZ5DL17iepn3BKj25z97ac3JtZSxCbdoPxlgur17EQUNVr6AZ9+OMLw
         QipHf7iSkYAwH/vtZNGXOcjnsmBsJWAwWBRpOoNJN4DF57Yl275eHdjt0hY5K2SxzwRR
         0kEOgJlQXl+sgxNpHxjbt6DP9OffFbFn1p/0kmI+yPiAxddzpXPU2VBWvpcGPc8OX3QA
         CQvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795360120; x=1795964920; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IgthaxTJeqjgkIgsu2LWRipxKF3WuNFf5m2ROqkfnrk=;
        b=Qxn6uF98WEDoVlEgbmCaAo6040uN1RDmci6gK5hCvwtnqskoXWNKHlnehsI9vD5BkJ
         x/web0JkqoKDGY/A6iEgCVNTpQgAjvUgJLUJ+s2lO+YJn692lojq3sXgdE6lqoocR07P
         /TbJxpo1lfaYAese7IQFM7LTPFxd4tmqDozran4ih6TMVo3Blf6li6aQOAhbnpue66NU
         NGt0/kmgLfYl+bKTHu/nJ9MBd0RCt2lbgP6jtxiFms6ywY2SkOxwK/d3wCh34pchr9Fz
         Tu4HHX80dCzebhQncjJP0LgAk4grLgIpYSoUef0JMMeuEVJecEmfcmWW/uUcgIJXUYhN
         cpuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795360120; x=1795964920;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IgthaxTJeqjgkIgsu2LWRipxKF3WuNFf5m2ROqkfnrk=;
        b=YsJGxQNNs/SDSTZCvZy+R9qUAwDuUnapCmDpKQIR9GozyRhYWhzscvCqENidBVs6nT
         M4/JSBzTyKxaxBi4ywUwbRNSFtAkV4p3T5Xcn9KcKgX/rhdxAkRaJmkrFkO+/SGql4Yv
         QOGmU0xYxly2U4cGelc7AWj+EDK5r+urCpKZR1K4USIAo9rEVkps1tnu/lNuCoynId7e
         AVmoYiYpPOyq8jEAGEQ6jJ9N5ZqCGMqyBNMz3UjSlqtZvxwymfQx45Mo7eEI/vJph2cZ
         Ez7ZcD5274hDD1XQv37gXeM0seCX0ZtIlVFC5NJHfHXUcr/2a2AQN8VWBYkaWnLT0aJE
         akxg==
X-Forwarded-Encrypted: i=1; AL+hErFOZ4FmlmJnkWQ9m3gDn8A+Pi1bsv2TnO6AiI0HeNPNRSzJkrHbOs+a253zx+qjcCfthmztQQy2Pw==@kvack.org
X-Gm-Message-State: APuU4Z9ushd+Ue69xrf/ybrzDzooGNwj4+/5OKzy0hBbAatleKOJAE3u
	BS2R7T1WRYKfyjWnUn6mEJwuMWxixZClmiX/+bLm53xNI9uF/6tkx4ZaOSOIlX8+riVC0zWfQ/H
	etcUjS3/JiOVtpuf1F2OTQjqOMV/oxEk=
X-Gm-Gg: AZFdTZeGkbYCgoUDLurNcZFUzcFC6m+d5yWrwvaEb8/Gb2nbW4IYcsPs8VF56X/6iEz
	tsuApalQb5kWwKAlcmRsS+HEXAICdHPRP2cfsJtluOPEjcVx9sd1RM00m4ZWrLyzgPzqzRvsdKx
	31XqYun7+JtPuNg75abtyXi2iuRTYN0KdBPJ7LHsCTBybUFJCSyg4WapNMuDH2K76dZ+DuDBS9a
	rwDVNcPVl+JXUnQXxPp3za/ao1wweMEHxFdXc8uQOT6Ss4DliyIxiauBdjxAZKhSordtcY4UcR/
	Q1g83W79aa5oBLPtvL75YQmXVEkSTOXdPBf7z0NEed0WDC+p12EjM3WSoGDoS88uhP+LnbNZKja
	5Q53+QPPCQEUVmWBWjJH6wwEPwM05zRnmKl/z48aB0j++RDbFyB4cjydEhXIRbNEfYIMUiyPRq/
	cvecMDV1PCPWAMNgiY/u9weUmlmTbE
X-Received: by 2002:a05:6808:6404:b0:55c:836:5955 with SMTP id
 5614622812f47-57a0bb6ee75mr8984155b6e.44.1795360120208; Sun, 22 Nov 2026
 07:08:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-2-sj@kernel.org>
In-Reply-To: <20261121210013.130397-2-sj@kernel.org>
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 23 Nov 2026 02:08:27 +1100
X-Gm-Features: Aa3M54pWq4nvTo_Vd5jmEckUB6yZoob1KXNjUOEmdWFeILaYTD3zwarplSlMKK0
Message-ID: <CANOyQmFJz37C9dvnAiNzpbt652iNbLE-mLnBWPBoS6efm7zn2g@mail.gmail.com>
Subject: Re: [PATCH 01/27] mm/damon/api: introduce struct damon_report
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	lianux.mm@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53EC7180006
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: huf1ginoknonxhyr7w9m1c1pkg1xufws
X-HE-Tag: 1795360121-677875
X-HE-Meta: U2FsdGVkX18Lu+YW4YU7E+8Hi46iNepu5nPv9wh9NKGvXjnEfD/qdfFAGqhhN6ZxNhUed7igqXZNqgRwFFo/1E153qp+kl5fQDVqXQsxdZCyGJs2O6A4QC42aD1hOLtFqAD16QeH4GfrNL6guB/yU/71T5UukP+2f+6POsDR7zbQkn0bksRV9i/MCRxcbf2wiNREkrIkzVM/CuXwcDhJZmDXcerLJmMC8qcTdoVAFLblu55YvDc+S2sOeGnX2LobLTl3Jq117QrTFUcJdcxui/Y6isJtAFLhO5mhh+2wWWExWO3x4555WgneQcCMopXDyvl/l51WtOis5O5Et5SRmQkMdVJCiNtv1b/tv/YJN15T/XE0rD0/qotZZWIRleAha3disUaWUMGS7vt3rfV3xxuOf6Tn5I52LGCDXDRRY3QqRhXMvP1LemM+vSXRfQGGSVZsnmAGGsEKte/YoLEoncjCy1eo5QThbueOLHoV+KvsIlNrdbODvltnGT/WmciW27PHf5di6lwMG7LmXn5GH1OB1jVwESZ4NY1+B1ZQyt9v8hdnuZRzEcKVzw8JctJyZm2yW5nc2BW7Pu5RsJgub3S5galCXLalTzcgSfXTA/DF+lej9/Ou1WSPAGdICzKigBYCTUnN4huaztbFcAg1C4aStlQ800EyKa8vgxpgXOQxUiuX50jMZhmt2cP6N5Ux8FQw1egV0bRrOaZqGTKJpJsckw33Szz/WRNXbnAEcF36gFnWyc3PR3wxvkbw+Q7X5miBk8YBGLwHunJnBqTHZSfgHaBMYxwoNPEpQd16aK+mCzMFFGQiO9H0gTiHqE2z7jaErQx/cu6snJGxAUmrxiJP4ZTS4jts7By31UVjh2Ag4JRosqpka2+f/xK+eW/o8Xfh5tu0+P3zjLo0UrIXd5o+sZoi62Mo/a7jN4VSOGW3H5Twt0htZ0d5Pw9dvDQN/dmDFeVd6mS2jIrzZBI
 j7fOYfTE
 QiQFSMv7kyu1+k5zUi7SvxKs+FCA77q+NlCjL/c41OOV4tB7Yy/chxmFLEJm5xZrTP2BJ3wo/Drfxe0q6QV0/UoK7BC8N82Z0/qpCm61q18N9ZqixGkSLhSgnuzj3QbILTFvb0JDDDTb3aZyNYERxd6ENBMvcWgRsEy9/pQYbjSqjwa5n0MvAio2bbKlHuCjI43jnwMASe51hR/ks6UECN0B82+Ivaqj5o418vOBH56Y3nGvDI8RlukhOP44/oO47ovVhCtIimHWkO9DVn68/19dpDFG2ROUo/+C2krV68OssalPc+LHQ7qxOfd4xyNgX2XqWbSK2YeFZe4Xlom/GTW2l63R24HQmVGHuIoUm1WHCo+5F7ssj5rYxzwVscluRU8GOfxu8a65HSncJgktqgefsgGvq7qz+XkBMAex4/FqwmAZVlmT77ihRRDvSXB8gGUFVe9arAySiM6CnCjuePbokzYkYCYL7QNJY+sPbhz1T2yDHUYxT8zrFGfcGGgKPinvSAVR63cEw8ttbInpRRlZnVwCrV/i+JzbqverOsAANDt+mSAOp1LrBAOq3qb0wijyyUQm/ZmDqmlCYB9gkz9Ebo9Lylc+svBwzGA3zgUO14ubnuxN82LoFBHP1UIoeWRfdwJDESU0WlURK1WcFiFSdQOnuAdj9l0cvMcUhJhLdsaUSuumv1wP+OcuLmWrgSgk2rqIhuOo6g6PR/kG/uIalUj6yJ8lr0pyBO+EoO5qBKzFYlkPrmJqqS+7E+M7ndT6d0QNqia2HcXRcJ+2Pq1Sstg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sun, Nov 22, 2026 at 8:00=E2=80=AFAM SJ Park <sj@kernel.org> wrote:
> Define a struct for data attribute report.  The struct provides public
> fields for the type and the memory address range.  The type field
> represents the type of the report itself.  The address range is for the
> memory of the reporting data.  Data attribute producers can format their
> report using those fields.

LGTM so:

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

