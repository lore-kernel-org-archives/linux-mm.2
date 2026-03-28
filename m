Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A554610BA423
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4EB6B008C; Sat, 28 Mar 2026 15:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174D36B0096; Sat, 28 Mar 2026 15:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069CF6B008C; Sat, 28 Mar 2026 15:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6C3A6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:18:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FB8D1B70BA
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:18:29 +0000 (UTC)
X-FDA: 84596433138.17.7F1CA43
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9B1D84000C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:18:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="U/lQd1um";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774725507; a=rsa-sha256;
	cv=pass;
	b=546K7BFW41pGQxhT/zOCLOzI/2siW6m35X1XVTWQ2uwAlg2OjcFHtMmZ0Iv+4uclws4Q6U
	ldDDqdQ8rw2Z0I0XDjqta5h2PiCh1c1ntz6EQb+Cxb4h/Je7fTmVrrIkngtwNlpCMDLXbj
	FoCDZewH+hEbc/u6ZF7vNNo+eExyAoE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="U/lQd1um";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774725507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAIQbT/xVh9Td/jwbrsmWvx0zgLMuZbPJRxj+dqYV4E=;
	b=maMcCSODqBSAMEVfq6PbqoNGb04MthWsN34HusQkwWSQd2BrXMGQbd6BzSaf7Ay8V7s1BU
	06a59oPSM/E3qfoRMDS4JIIusRdLWvSmquT4/J6oraxw08aWc9epDr6d1vrweb9ou5shlV
	GjiMruPN2AmwPb33CrLEfFIC/vhrVG8=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-509062d829dso438241cf.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:18:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774725507; cv=none;
        d=google.com; s=arc-20240605;
        b=BQmustwTjVSU5EBKUqiz0ARRdcmCzbPH9y3EtLmpbJJbvpEMEgHQARfLcv5Ng+Yot9
         WTKzK9WkCB31mqD4dpC3eLfM9uFz9c4Fvkb4LgAwczESJVu9Gp7MXl7MZmifm+06LHrC
         Gg2gOWN9C1PC5VAnu60vuZems7+ZGMPpePxL8/cW3rDlv/V02SjRqZgRl+WL7Lvat03y
         q9Lx5H1utjMVt7uPMsnsBbtfGSE8tHiU6zPPguRliRoen1CfgLrjWQHBZoBoer0L1/1g
         UZyvxsdMEvp0i32DvukIIgj8w/dWf67V6IClf8ils4JfPC+5qecejVA3gLCOpaKIUuTL
         LeNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WAIQbT/xVh9Td/jwbrsmWvx0zgLMuZbPJRxj+dqYV4E=;
        fh=kC+yqWUWF1Q8djDdshELOVgV0iVzHxag+XsSnrRfchI=;
        b=JQ4HPowmb4DUupf9H2adCYMrZ4c0ozzEJAbi7jArpsNfBw3eTK3CeoSRZqDI9mjC7+
         kMs6ISQUvrYUzxadTVjxKSx/YygaGvP3utN34HvwQ8f6wi32huHTZ93PWDvfU2XyTLBQ
         nUSBsVPCR/xbQ3iPjocBZhKhBop8M1s5wRDjYNiv4Sn77uILQNwuDevWbhn29CAHuazR
         M+gtDlQrgTOCFsckUrTgzte3+Brjd7X3fc22zw+/CQPab/EqFqOV82zTxaux0egx3dHO
         LHuJgCayu+VE5aD2dBF9DAsi7knhHGg6QtTdmQr61wJcRafECsrv21eXv1lPrujjZD/F
         4fQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774725507; x=1775330307; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAIQbT/xVh9Td/jwbrsmWvx0zgLMuZbPJRxj+dqYV4E=;
        b=U/lQd1um8lt3XvlHAoQhy7QdHUKp/bV41zuNPu3GxJIMvOOq3ZsSFkzQ/CNIbadm7M
         p2iUgbRzQDr3LEqyFhDoABek3VhC+uVbXzfgkgF4WpX64l16Y+Zshe7tIyx04HdxVwcp
         syggLLmCb810e7SSdf3XtoV6MmADpzRJlTK8flv5kiQyngsoH+0+V69l35uD+IF6vXak
         5O/bDipuCcNLiv0+KiHcD57BRK6El/EQjLiN+MPn3O6JP9yKLYRdyO5xXO0WP7hdq0EE
         nB7n3PUs9itfaJcIBYXNoNmWwvx1UGcVplgHyn7fBE7funBH9i450xhCDFwX0EwK/GCB
         46wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774725507; x=1775330307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WAIQbT/xVh9Td/jwbrsmWvx0zgLMuZbPJRxj+dqYV4E=;
        b=ejR1y0KAVyDUqIjn1iJ9BQplOrNGF75kPACFuCMnE6VPDOt0SFePhQhXGo+6rsdysa
         OyWuoNxtrvd90Q8Xby3HyArzIe+F8onBng7PPJ6LNs62lTchob9tcE2oirEpHZDRuXJT
         AuLZsUnrehD82Of0lzrDDTYKNGyVM0wCQuYXUH2/4CYrdPKQnBPkL7/CR5mGq6UPhc49
         aYL6Qec1i9/p2kQa5SApr2WdM+sE9/3L0xQQYTKQSxNssXKcCM4X34F/bFM1yUY0f6Oc
         shTla9kkd0UW4QfzosBd1lSGrSp620BConCxmooKi0a+CKvuH+WFY5nMb2LIWzyRHeQH
         1wTg==
X-Forwarded-Encrypted: i=1; AJvYcCVsf0724gQ8ryDlXMEq9iO7F2RW+rFDY/GDCxJ2cfzQS4HpeZyTnXzWmZWdSWZXJ6WRKOkp/JZO6A==@kvack.org
X-Gm-Message-State: AOJu0Yzbgz7wuNmkSmCiEGQ6F3pKa+bnu+jfQe+IrEe9XCG7PvrAnFne
	z0rP0UfVt77xr3cYRPyv6rpTVk7hpaKbBQuy2LbYl6Sr1elq81RI5uN80uJw1JcprizXGP75OGc
	t7JH+JbNCrMR3W90Gf9nKO3Fmi5xCrpfrHQsHfIDg
X-Gm-Gg: ATEYQzyTkYdFoQ4KGJihawNU30ekUXV955gviVnY0uVgXTOQmVYQ7EDlwOdFmCzlVu2
	kQS2sonrW+398eAu9vayWFKCV+x/gq7i5xDP0axOPi7vVTcdnkB2grXNjJ2hiGIMj6sNuosBjap
	/oXZHmdxy/wQw5xvTjaBy8dQRq2igH/EwIUBeT0CUC7FN7ADijPepgPxUjp3KJs2MRZkmBO4mEE
	NM0qHc562O+Sn7MCHk5o9LyUJAtRkNqHbd34nDB9PsLg1Wm9+TuIzv5H//6lTeL1CCydjvsRlS2
	p2caBA==
X-Received: by 2002:a05:622a:98d:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-50bb27b5c43mr13532941cf.14.1774725506157; Sat, 28 Mar 2026
 12:18:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <98104cde87e4b2aabeb16f236b8731591594457f.1774029655.git.ljs@kernel.org>
 <035bd66a-da28-45ad-9ced-c17a2f4e6806@linux.alibaba.com>
In-Reply-To: <035bd66a-da28-45ad-9ced-c17a2f4e6806@linux.alibaba.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 12:18:15 -0700
X-Gm-Features: AQROBzBfRmY_lbYW2VdejKs3qABUczupFVXmVPSJNTuZfToa711GS-EKD7PJJic
Message-ID: <CAJuCfpEZf1O-w-NJ5hLsNBqSbWk2xjyuBF44QyN_qpJ6us5rVQ@mail.gmail.com>
Subject: Re: [PATCH v3 09/13] mm/huge_memory: use mm instead of tlb->mm
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 14dr9esr8cqnsi6ihemd5xkmhdsn5463
X-Rspamd-Queue-Id: 9B1D84000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774725507-986453
X-HE-Meta: U2FsdGVkX1/+IOKEJI/zIxOtsG63NEMltBNvArp+1mgJvBYNowaV+YHFDe5W5S3CCAVR3AmJSdVs3ghAi0n4CVaGUFsoZwBzRpRWd0L8lz4yjdlsn9EX5GwEjeHqi4/Dfx2KbpMeGNr84HdObc0NN8QWS9O9stktbwXL+QHKzhiNOJz6Ee69otGvJvi6mpFH8Wp9HMRMGfwnxyaPhslZrDJxoYaDX3k9yzSfGZhAcM4JcRTue3xN2ddVDKiopHE7L3i7Bt+7bjNKLjHsa2h5NxgU5XALeOFAly00oziicMe9ard+myXau7lfFK5U8LuWUOV8qGb+CT5futhpbZHXgs5lw1jqE/urj0UL3SlcCl0nDTImwb+5Y7J9nUG1VwxEkNWrytZ+lXLZGm5HAEZ/0y8w+w5zVFUUKW3f2B2Pqg9asb8TNXHGmbQtn5xAJ9u160QMa3suozr8QosnZhfYZHeQmT4Vj4vlTnmjSnHjrc/kzphSCZOibkEmyR0gt48qJ1JUBZrbAgdFAwahwQB4Zqv4CWh31l1riKfMhT5GVQB5BVkoHbtFbiI+jMqun71W4dDbVC9oCcPMg2k1iHCEZBmsuUC+gFEtnOGWQrXK6UXJyPgohH3z+Tb8vE9DvsoO2xXEQ5TRHuP8oQllCNe17Iq64oytfLUcGu3kqio19vZQ/p+OHScKkidq/nCoHCNsMON36uoW5Hg5ZmxlLmqfswxL3coSUOHAdH2tuqedoLh8n3Jnv8I3jfCvBiCYYoUzFSAjUzygNIXxPPsaAwyaxEYyeT1NkL33vGF+dMw5HP6xo2VaTJWIZMcbda5Oc7nH8dh+zYP99Y3OKBxd1nkn84hDIZBXXeePT7j5yH+C6blG2VaXgDOFcDsmVWo9TiEn9re5PXZi+MqapTfCwpcR9P3Y5gIreubdFji2hUlSxL2qhnAQ/HLdNImKiL/0x//Eg8FLo/8RCdG42Inrby6
 z/2CUokD
 Rl7tYZFA4HwdqYUD86JrULmBxFNYHcKNWwdQKv6olg36+2FsDOEmaoruPxEO0XboZk8QUG9cauXS2VLhwXDIONy+zmyL1g2VFuWCZ4pQzVEzUY6V0oka4daxCueP2t+fkw50ulh2gVKBbPe1cxkRQIL1KNqDpffHmM33F2vpbiRIPOV0SNXThDbBW35sQaBuep8Qfiqf78Txuulc8mTgFPTcCA6fRFsY39JG1tt4XblGZAtdUfSzp2AOsz1wwRflkYXQi0+rTc019AjTFvt5FWqvQK7Zw16id1BGv1DNm6EobxL1k+kBIDPPqaji0ZsYQVV6Iv/b/58zlfkSfRUGmMBpBlOBOvMEe+Weapm+rlzbMFHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 10:42=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 3/21/26 2:07 AM, Lorenzo Stoakes (Oracle) wrote:
> > Reduce the repetition, and lay the ground for further refactorings by
> > keeping this variable separate.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
>
> LGTM.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

