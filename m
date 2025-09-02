Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC026CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4305E8E002A; Tue,  2 Sep 2025 12:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4094D8E001E; Tue,  2 Sep 2025 12:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344868E002A; Tue,  2 Sep 2025 12:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 26FC08E001E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:14:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D75B111885E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:14:03 +0000 (UTC)
X-FDA: 83844806766.09.7920D3B
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id EB3C314000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:14:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gR+rGHXj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756829642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jytiQaq8S3k51Q/Ee5XOzpJH6a5+6DrfPCaoRasu0fI=;
	b=oBf/S1KIRyXeIx9SYMyJZqbw8oDaEiGV4m01EUqPfIRpdw26VUmFh1hMghaKLG7Fx5HHaU
	rJ+wjLBaTmnj05pPKkPRScGG/Y/TnEcBY1mVgn0QCTjrORMoxSOQASq2bYzCxJzxVmxP6G
	wFt/EsV7asrsDP4778gpZa7Xhe3CJjE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gR+rGHXj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756829642; a=rsa-sha256;
	cv=none;
	b=cGLTOjhjB/OPPgrCvUAT/sGSaoXM4cghg/0ck/hCagqu/s5McMUphauWc8SWs9kEKXguQb
	GXsN2CGqqVlYBnkgOwukY/V53vpCElEc5Ck9GsApTjLexc8TDehmzKXon1W/buXv0oWo9X
	OGBhB5ZzDhC8Bpay14F/PM/rTy3zY4w=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61ed395ba46so2878a12.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 09:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756829640; x=1757434440; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jytiQaq8S3k51Q/Ee5XOzpJH6a5+6DrfPCaoRasu0fI=;
        b=gR+rGHXj/9XOPBFyOvsd1+SYXQ8aIsq7pp/I+vsrE/kYB2nR4jl08K5GZRxdDkyHQw
         /XGR2dKBPSYt82TM0bWH03G25wY8WXqMCJdktJJw2SOZcrOW64MmMVx7/F/OfxQiwCL0
         6BjBgIG0J0sebrrGFqTfHW1hFG+hmKAlGEzGppH8bsdUR3lNm+wSixNjI2iEFVby1giY
         m5UDeA4DWBjkhcv6zDGrsfE8NFrU/NzinMWfOTxT5NgWYwkAS/3QrWR08+w0jKi4L5lJ
         CQxiScoCjAOqbVTmyOqT08ea5p66EYFkObfFtBy8MflEMsdGS3yww721BoXzOd89ueIQ
         bK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756829640; x=1757434440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jytiQaq8S3k51Q/Ee5XOzpJH6a5+6DrfPCaoRasu0fI=;
        b=UR04V14xrtidCcbdh/HE2XHuej+8Kf0n8GSeBND+Ekr6EcPMKZ3b1JfwTi5eFoaSTM
         NkgoiwRImw84mOvU0jmuS/e2t+RHgVFvqeWR/fZXO99A3NSMDXSH1It3OYCQ5z/jHMFQ
         wIDoc7HOw3TbbQQ3de4DF75CUVy0OBe50CV+DM2LytAKmNaEXqlvy6zSAc599fvrS5xe
         RxaWApxskNod6qCUqoVhp5nZZyG4XU/ckfrtWP0gjJ3bMmpQMYcSJzJKdC0MaaFJXoux
         w4hcWBYvf669fZ2R5MBabMnhbTvvitIOZ54zQHjJ6c48yune9JnrJ9lB6Gx07HT1ewsY
         1W+w==
X-Forwarded-Encrypted: i=1; AJvYcCUAaOWMl4yJa5cNbwq11xEt/4m8+9PMtsCZn0IuF6zvgkQxYyBt6QHcAryree7TLJm0GRfgQIdYBQ==@kvack.org
X-Gm-Message-State: AOJu0YyHHO8BqEQpwcky23dvyzKNiH88E3UZt0kxp2JeTTjeVBXP5mAy
	yeZxbxYnZgvpFs318n1RwDL0vS3Q+G8qa0XhI3MZrg9joJgOf0MDRRr92oGxXjMsLJF4MPNgT0X
	YiKwQ0QYjv+Fhg5mjS7OqXFU1f0vQvxP4zWhgs1L3
X-Gm-Gg: ASbGncuPVyPhor2ddeH2BT0jgo9vUmRO11htyPwkGgcT54FVi0w7KCTXiOBmQR8CRr1
	dhtAywGl6CZ6usY7H2wVrr4gneVyKDPcR2ivZFJBgFMkaqEJA0eFxTPjcJ8WBKTU6TFvmv6b1PZ
	MI5dFoKYZKrngYv4Meu8KmSHAPJ2v5Gi3VT2m17sRFj2APRRx3cHeTsIRjYSoWXNoBIR6uGCj/6
	ynFPzK3GtqEpi53TGcQWQbd6fhCFyCcPfz/fn32bQ8tfhEGVAbZ
X-Google-Smtp-Source: AGHT+IGEaYL/6YHpIvXgBQHV5Wk76XcCDRpGWCraR3NtcuU4rAn6Ck90h/ykNLFpnEGnjKO50Et6jzVvGjXPfXbldrs=
X-Received: by 2002:a50:f617:0:b0:61e:c6ae:7a58 with SMTP id
 4fb4d7f45d1cf-61ec6ae7f13mr61921a12.0.1756829640144; Tue, 02 Sep 2025
 09:14:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250226030129.530345-1-riel@surriel.com> <20250226030129.530345-2-riel@surriel.com>
 <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com> <CAG48ez1q_Sgk5nr7Bngyt0UB3FkYb6e0cHv18wqD=sLEdrZkmw@mail.gmail.com>
In-Reply-To: <CAG48ez1q_Sgk5nr7Bngyt0UB3FkYb6e0cHv18wqD=sLEdrZkmw@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 2 Sep 2025 18:13:24 +0200
X-Gm-Features: Ac12FXwyx0L9zIZrTUl0hsCo4DRTysWot4oLg__Szbm5KqsLu80QgAIdMR5Q9ks
Message-ID: <CAG48ez03UYAdqZcQxG9ejJFnSNE=ADU=mn-_zk9fmyBzTHo7QA@mail.gmail.com>
Subject: Re: [BUG] x86/mm: regression after 4a02ed8e1cc3
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Rik van Riel <riel@surriel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	bp@alien8.de, peterz@infradead.org, dave.hansen@linux.intel.com, 
	zhengqi.arch@bytedance.com, nadav.amit@gmail.com, thomas.lendacky@amd.com, 
	kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org, 
	jackmanb@google.com, mhklinux@outlook.com, andrew.cooper3@citrix.com, 
	Manali.Shukla@amd.com, mingo@kernel.org, Dave Hansen <dave.hansen@intel.com>, 
	baolu.lu@intel.com, david.guckian@intel.com, damian.muszynski@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB3C314000D
X-Stat-Signature: btuu4e4na3k3jpn9m9aymje8emk3tb3g
X-Rspam-User: 
X-HE-Tag: 1756829641-729316
X-HE-Meta: U2FsdGVkX1+SYx9mMB5BBfxxuFk2OeYKa2DQpcWTs1SIheUpx/tffb9xCwJGNe8K8qJAahCBh7iyNOfoqoMUKVk6xu72J0hR3Kl8OqSeUF2OrKRsoHJRYToUywRgLVu23vsRmgpfiCj19exUV+9Y1AI3/TeuvRffh07t6oZwiYsx/j61MWi/WJXFjy9fJNWrMyx5XwL2Eb0/Oy/7tEjkZe6imAZM9YnmzHq1TeqfGsGjpT08OficBmzpNxyTCODnq99/jBN3JBgtLutYqMgoXdlwnYldCbofQJjmx7Kd1xu8z7HG/hbK38UKRQSx8lQMs9+Wf5RkfPToGZrLhT5VLVylkOJmrXi9h9+jAKHQFczei9CcGOVNtWFF5i5DCHWYWlrktW9eYV7+1eg72EwuTEZ7JIACVsqNLjnUCa4eXl5ZZ/wlgFlpQYHXVPfqLapMVsZpQMkkq9xHdkkVBK9HLgE34MLowRzb2Fk5eDXoDfpXepEeH0oSfte7g9AfF6sR6zamSS2zCtYdqqxx0ba5LsyGt69f2Aln2m6wMqPAhGsroZGMu0ep42dqFqsGlFK8q4XKtvR2UwZgGo3Qw8uYd4RLZD0ikOG41bdQf8pLBLffSMlm24z0HUF7gWaLCP812pBRBABPYhNPv9HzZfnCyr7RywPYSBChSzv1EJT48+jq9IK6UWxpv9Gq5mjCuH84sYWrHwqYp5ykY6hpwQueznm/6/H4y+9zZEz6TUz1aUHDH3zm9AjhTHxfAsyiZVHxE+U7ZrlPCpJHmEttMQHNKuFQKK+zJjlH99dvOixb5vVwwsCXfqba2EsEg+vAy3fagWwdHxh4v7sYIpDWf18yjZSaJ7ts/q2xXZ97AL+TBsGLtHSMlBsgsdb+LnQB6Y6uXjlqiIjj0h5VBMo7k01E2D6iOfixxYqTKzyoDtEQ5UJjbADuAfD2H1XXBm59Ugqs/qughUeBNXzAP38Wk8s
 Pzb6OvO2
 0r2NMMisN/wcRud37vDxXdLwTQwSpW82rwscwX1Ez1z0dDKCh4squt1LJ7n0PXqlwxReWXzanCWEUKtcdjpwZjPAiix62+QujlX0wJecjIrpVN6mi0wt1CDnP/84S56WeDlmqCIRrXvKg0c77LbbkMBs+6VChbEGXmIOSj7Zw+eW1Q9bRqEaHMX1DLkwx34Rot5qooJnmWa05MQ4xPGoI4Dr4CMVw15YyeEuedZ9wWuu9xZOZT6GwMmZMTmjeFMjgbLKjpeHsMqB0ZM4xWADLsi7hbs/hvy7rVEFy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 6:05=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
> To me this looks like a change that is correct but makes it easier to
> hit IOMMU flushing issues in other places.

(This was ambigous; to be clear, I meant that 4a02ed8e1cc3 looks
correct to me, and that the suggested fix doesn't look to me like it
fixes anything.)

