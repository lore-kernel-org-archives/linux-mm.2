Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC10BF557FE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 10:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98E16B0005; Mon, 20 Apr 2026 06:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E498B6B0089; Mon, 20 Apr 2026 06:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D391A6B008A; Mon, 20 Apr 2026 06:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C28E96B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:41:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 721CF1409DF
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:41:20 +0000 (UTC)
X-FDA: 84678592320.12.CA73D3F
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 755E140008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:41:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IYW779k5;
	spf=pass (imf17.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776681678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9clkba00KWEA/ZYqovhY/H/kT7YKOCxKbfsdjAbzOc=;
	b=sheytE+WiTL4tHLgcLUihU3g3av6kuIA2UAAObU87FQxmRB/l153XgmAqg+PmystXTJ3mO
	Z7KrmSVy3ub1TNf2bI4vpH/PqrkoZECtmNABQaMpvosD4v71nXsfrBclCfD8uyqzOE8yq9
	f9ot++mqPWXk38l6T1tynKjUR0n+Dmw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IYW779k5;
	spf=pass (imf17.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776681678; a=rsa-sha256;
	cv=pass;
	b=AJNyzpIufo546V774P5EVAMYaFKBUKvb1SlysXD3GGXRdstF1fNpG4dqn3kw4kILgjo0YZ
	J1+K01L9P73QBJ696LNj2ajvhsxQ+CWzg9w4SBbvTE8mT7fAuCGdN/6qzNBMpk+RE/6mVA
	TutbBKDPRIAiwmwQuici0YIdU39r0Hw=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43d77f6092eso1939446f8f.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776681677; cv=none;
        d=google.com; s=arc-20240605;
        b=aHPW8bW6ybyPG5z913bHM37i58DvhvIg2GGM0WTch0LpxWbOqJ8oYLa0gJMTLs2xTL
         HhmmN5dxh5yfvicbfxHwl0SHrXsEveveochX9xPtck4UrAbKIWvH12DuUppb1391Xu9w
         cd/cowYdkgu/38l7weKnWmUmpRyOdLkk5Jme0s4GrU7CA1KsNY5Fclbf3GWX1M+teIoZ
         aqLTLVoTBj925Dz0DI/VDHCjIcBP2DrELAe1XcMnElWXd+AhCrnc3qnFUOgW/h9iJDP/
         aIndkGdlzYHYSlIIYLfBZiV1iJtFeaesKPFfJMd19fGJzmQIUW/reCExrWfo0n1hG54N
         jPtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q9clkba00KWEA/ZYqovhY/H/kT7YKOCxKbfsdjAbzOc=;
        fh=ywL5aEOY+Mp5Ft6uC5dPZEPit0gzK1uwpNg8PJ3CiFE=;
        b=RPjgBhl/RAMNF2LtLVJXaqZfV4NplZKt7Vte/S4gzljxUdN9rFzBByd9RdQh0XEQsG
         mI+SH8eru2OIWIjP8DXpj+rQqIUDS/K/twFBqUPP7epwsqu8002GMkp36krt/AQh6aWr
         tLBISiyjWvTSmFpyA89Ooy0KnddJM2jvzy3ZoOoI+pOHGzqa4nxkrWqyYzn00y9+Mco6
         EoZ1uZ5yFtgNQRrahgyuEur2GrmG/EmhDSS12NFKHRnytmj3QNxIjVHwHuhw+IgY/JWy
         rVKgvesWePE87oe+45hTDxX5T5OOIjECU4dAn62FjaJs7wb0P1GsL8bCafXwD4Bg66TJ
         xT9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776681677; x=1777286477; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9clkba00KWEA/ZYqovhY/H/kT7YKOCxKbfsdjAbzOc=;
        b=IYW779k509Pvyicc1jaQC22pJBXpubrAi3MiC6hsAIzxUPYIZJMyZHvnTJB6oT9k7Q
         tXPimTw9YtA+/qgHW56A4nEbYuVmApBeg1F41YCVWHOdQ3ufMY2/V+aynyk7gv2A9wQl
         lH6mBEGF4M4GereXuBQWdk41Yw4MT3RwwmaAy22UaYopdw4DOU7rxef0Bul0hmuLEYjM
         S2FnbqJF8vdNpZ3lyGkSSMML9qgKL7U8oviQIoF0LbQ4dQQRs3TngklK3Zc9fdnUkKrE
         vxU+hDtJU1wvCSQaAWC6VqZMMKYab2Q0BpVjgj0bNTaXteNrew49tyLRUmN/avHnn1w5
         NUyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776681677; x=1777286477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q9clkba00KWEA/ZYqovhY/H/kT7YKOCxKbfsdjAbzOc=;
        b=ba4IjuRTQ37BTtu4CdH9yZKJab6XktYwqDR1NhUMdigb+2H3tYo3Mf4d+rixgsZOmV
         usEdD7bg6adQAjsIPqSamyVCsZ0dJLGutXs5SftKuffLKl0asyOiaWr/RGpHm4lbXq2h
         KslE4KIWTbcOD6hHkHClqb2TrNqE4KKB0wB/hSKxnoKB7uUYxJdx0InWgWuv89YzNIG0
         ZlYWyVEh9ZdGqN5CnnU6mAxze3Fw7weYGr90ExBW4lBeuBtdNhu8P8GZ+sWNpGtcVJVs
         dNx2VlcPIbSC9kVd2tSkvK/uidIiEw8DajthVAWMveCnA3wbeZzdVGc+n6HMy14Yz9fT
         lXAw==
X-Forwarded-Encrypted: i=1; AFNElJ9d9DKlKvnR1d2eNg/AxBpuuzHkKx+MaYt0wyBar8VIPKb/qrNVhPDsxl1EeL9Y3ZNOMYFa1K16Jw==@kvack.org
X-Gm-Message-State: AOJu0YwGJx2/d7F2Eb5iHza3MnNl+K+TflQ05JQ1heZqBlt611rSkRt9
	htmgbLDQakwto+GWARpEdyaJN6Y/RWLDnc2zWElEuOC9HCJ2SirC+ZhjpL3FVGbnGzkUx5/xlSG
	8II5z+mEfSiss3MB4zSbrCEwvwm5/Y6M=
X-Gm-Gg: AeBDievqSfUdgtwKpfpWy5mfLpRcIdHQiBr7am30a0K3BE6y2eNIvhUei0EPrSiLQaP
	JFPHCZSTSWfQBGnHlDRTcp6EV9RP1cDBW1u/4YKyDE1z+KXwf6QOkxnR2oGiXcmBkYGbxXvpoAr
	KU0LvEm1WM735YMTWzsw9RwRT9z96ALhw7pE3Nvbr5QjBS79piHU/Savj5NLvX0tUKYfHxuLSXB
	VZj7nsBBB1QzMTcPwT020uFye290IINP9Pne7vhvZNr+C0Ph4CtKcoua15I9an2XkUDTKiF3tms
	RBxgfAntdGqfn642oUukmMmgzpW1jeB6P5UAnhyKib4rKeesb/ABgZVA5HY269Aavp2LY0M2Ost
	24m6yNJw=
X-Received: by 2002:a05:6000:2008:b0:43b:4982:fc73 with SMTP id
 ffacd0b85a97d-43fe3e08fc2mr20693373f8f.25.1776681676573; Mon, 20 Apr 2026
 03:41:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260418000635.17499-1-sef1548@gmail.com> <aeNGbNyPxJssnkbO@lucifer>
 <aeOuCH8ydw_yzdXZ@casper.infradead.org> <c113f667-f897-42cc-a0e5-b8a0bbd91be3@kernel.org>
 <aeTTw4gziJigaNbU@lucifer> <CABZAGRHXtjzGJrgR1NAmVHFMP9eL5zZr3DaTAtAvywv_1sOHdw@mail.gmail.com>
 <aeXK4tjGFUgKDf5-@kernel.org>
In-Reply-To: <aeXK4tjGFUgKDf5-@kernel.org>
From: Nick Huang <sef1548@gmail.com>
Date: Mon, 20 Apr 2026 18:41:05 +0800
X-Gm-Features: AQROBzC4ljRClvtz08XZ0zLObZqZYUi9N_8tV--smCClyUXbbmXC1JSubeEDUHY
Message-ID: <CABZAGRGx+7Wbw1G+sjB9cdR-9C6PdT3OAWPMd=UC=5WHrnvV1Q@mail.gmail.com>
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab documentation
To: Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 755E140008
X-Stat-Signature: o3kro7zqazcx6hn613o3m6yrow98y3ym
X-Rspam-User: 
X-HE-Tag: 1776681678-547610
X-HE-Meta: U2FsdGVkX1/TGg98q5VVwdlcxScM3puuzb0QUzhQA+Ua2jKgYNsa77g94mo79fqLXbb6UiSXK9r8uny/DgMg+Oa2iYg1eDNbdcP76wX26LHLodc+8xd++TUSbRYx70u9oWEB23mNeqvBaql4ozSe2LLkRQ6LfMJLNSecjnkKSxYEQKoQCwIRDbyMLWUC5mcFV0eD+5DquOqG4cB6RHgcv5v95nwewMfiF+do/x3ff0w8nlJIDYFSpD5ZvCNbe/reHAvnO0BBN1b4nQOdTSnOFxZBIzJmxs4jypZf/zxJ29bBcMJuqQ8LV9c/9Jw3JlRiimmVBSoVf6eEGW74POi7Qp49qdWBN9GU6y/G5LQZSBT1lEHVI+8EH3PtI1l2CJQ8hk7tMs/l48UGnmlIRQWzSOnkeYxMz1ZOawBrjZTL1eKRmzo5ao581Ib5IZ1KvFGbzd9uo3SZddOSbJ/v6rmJnbdKAAM7Z16At6dQAAirgGOTmGSj8UnGfJlLjmeFTm2PHE8fYQ0HyhE/u1JU/OGi1+bijSbBjt1vmpXbu2+NUTFG7JeeyaIkxons8EfWQP3YWKRi1pjfSxu2LiTVPeAJ1Y7W2ER1auvpHUjpy3Rizzib1LZQCvCnSsu1xEnyNgN8wpxtKzMv7Er/LHawXnK08YwGoUHRCXZv+TEeb3qLsIf2clKpgd8565TV3yNS+SsH5ibZKtSjAlblLkTOOI/cLqBVszLo31Gr9suiwLTzyVZvbg/bTJdKtQ+yB4+UialZHR7N7RC4sO6sJrMTE4azOWcDl8TMpw9VtOxl9xuTj//ysqWfz2dlNebL2MgOLlHJvaEj0QYJUkhoyt1qmDap+c2/ih/308Nbk5t/uDQXfgV9JY7pE2navlAuLcszFVpKFpAZSDPZu0gLu4bZFVP1WGbFq7DIDFIwC0wvG6Yhu339ZJ8fEBx7o8EDF6WhEFI8A6pN2aovXIky58Kvwa1
 cjaSuIiu
 aoepYmV4LWEd+PhAspztcxBOQwXQEdlkgm+w0wGkRS+l36upJtzXjHYezcOmif+a5LIBmea0fUTlpVVg0X2SE8FXLhy5DVXVjgJ4SgjDyKDbIhFq1nU7Yd1pz8hPauHr4/ejjO4NkFSs0X20etirk3Kfc1MZgcWZrTzhTmwxg/hAf4g06GLN0Da2LdQrZSVoybtm3v+MR0gJZbHVl+FcMNQ+5qNR5peWKuiUTiWMbiLp5hkgDA6ogtL1ICGNgVxQnSUnzFGfjGysAPri189svq4gjukoYdtCbYsVF/asUnauKJKfy2jtvjWWUOsrrBzNAypiV2+eYHrncHAgzCHWhSsph4POm8J5F/DMTEp/JxfpgI+x1vI9t3xv6Y72P3d9k95vBIo9At6FqdsMfycwyhLRk/lQ2voqt5Sf0VRMjQfN+Kw2onwc41LlwScEF9aSw4VU/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> =E6=96=BC 2026=E5=B9=B44=E6=9C=8820=E6=97=
=A5=E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=882:42=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Hi Nick,
>
> On Mon, Apr 20, 2026 at 12:52:25PM +0800, Nick Huang wrote:
> >
> > I am really sorry for causing trouble for everyone. I would like to
> > ask which aspect of mine was disrespectful, so that I can be more
> > careful next time.
>
> Maintainers time is valuable and sending LLM generated patch completely
> without understanding what it is about is disrespect for maintainers wast=
ed
> time.
>
> > If I want to make this kind of change, should I send an [RFC patch] to
> > ask for everyone's opinion?
>
> If you want to make that kind of change, you should start with researchin=
g
> and understanding yourself what the code is doing, double check the LLM
> output and verify it and not just take an LLM slop and send it.
>
> > Sorry, I really am not very clear about the process.
>
> Start with reading kernel process documentation:
> https://docs.kernel.org/process/development-process.html
>
> > --
> > Regards,
> > Nick Huang
>
> --
> Sincerely yours,
> Mike.

Thank you for your suggestion. I will read the kernel process
documentation carefully.

--=20
Regards,
Nick Huang

