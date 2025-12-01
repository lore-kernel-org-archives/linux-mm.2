Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBBFED116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34FBC6B002F; Mon,  1 Dec 2025 03:48:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326E66B0030; Mon,  1 Dec 2025 03:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264236B0031; Mon,  1 Dec 2025 03:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1808F6B002F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:48:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2E25140B33
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:48:22 +0000 (UTC)
X-FDA: 84170275644.03.C959313
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01BB6C0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:48:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aDEPmdBX;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764578901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/+6NtM3DLLWRXnxxWZEHeO/9rYRoXhQJQeYTaoz/8E=;
	b=gfnf0t482N03RxBiJNLL6mMPpSLMZ08P61w0wg4VGpm0sve250xG7AM2h7UfMro6P+bOAv
	2CdHhS57yoRZtvrPsfgWdlzaeKU+GvCwYXO2yC2sTRwPk5k2GFaehSlA/hiQDgtv5UtxaF
	BhjHSFIIluMlt3GYlNbZifuqIx9ie1I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aDEPmdBX;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764578901; a=rsa-sha256;
	cv=none;
	b=PHFKld/E/zivmd22rUfgZWlFkTSY5s1SHjm7gKWF9lO+ZjXL8sFy+DLiadTkd4v5SUo81g
	OskFVpB8ubIgBJQ8XDi0Ipsjdboi9swkUjzTOBRdtH12bB9iLBCRLOSRQvANKzOZGdJ2we
	BMaGKYeYavzaGq9qzjAq0Nibv9zzPZo=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b1bfd4b3deso294641185a.2
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 00:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764578900; x=1765183700; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/+6NtM3DLLWRXnxxWZEHeO/9rYRoXhQJQeYTaoz/8E=;
        b=aDEPmdBXqCLz9MVY+CpmBePqGk8Mwt1FvS5qY+Ukc7d6O59pT0db2YPLg+ayrFztKZ
         e2OUZb15BUTGYE5eGDNO+p3venadb5Qufjy4Q4OaaxaF+g0OWg8i5XIEyEO+V6qAjYxz
         Bje47yxzXHEqZMr3OcHVuix8kiX6Q7mtMKcyjCE7VhL5H/5ztaSIc5hl5Uwys4qCAUqC
         7hDXxPBIeS5gUFRp0+hlu/6XR9ueQuLWPMkljVCs7cTyq8PThLMeyYLDw1fN8ayOjv6X
         E88Y5NCvX7d+s7fGbwDb/wdH5F7EpQBeL5vKDA2OqSSR/ZW4wY6/8PwfF456AnOB6w9L
         F+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764578900; x=1765183700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/+6NtM3DLLWRXnxxWZEHeO/9rYRoXhQJQeYTaoz/8E=;
        b=pzd0zANX0B/dn1ECdJd7Aiz4kXxImXoMR2jcUZpwTJi/xZpSa69Ug2BnUpMoFCt3b/
         uZImDM+dLN4fzuDlwV8bybDhYb/DggFojL1fR2rz2TOpcmvGO0Kd4yEbGhLd62V5Dz/r
         hkaFUNRGbfdCOBZqGoLsOXNPek+K9HdteHAduQyMmisRq1DO9kkn9mzMm6Y4n00DBIUx
         ak9OeqVRbRyRBn+xvlqKmUegGjjhIiFIUmPzp93qzsp4TeFIRc3ybvn24kLhOxOgcdwj
         6PTHLUrA8tp37hQDxueG8X2GuViLigSxhHAOnFoXsSuzY+SgBBKiB3ziviy9tI/0RNzZ
         NkIg==
X-Forwarded-Encrypted: i=1; AJvYcCURMiZjg61XMHFk/V1+d8B1pGli9xL+So4gH+iXJJnXV6Szj9VXvIbV22NByCkeliYjKVs6SViovQ==@kvack.org
X-Gm-Message-State: AOJu0YzuMuDEQA+BThbaXoVsUbmmITK/Phn9EWfGR0N7eJVaUpMSxtZP
	bymjn/DTGX55JyjG2eAmXbb0HeNc47pcGcbAzsclgf4hjyUGkKUZcbj4smDi3Hb0sFJuBIcyRuY
	lumRX0dM9AMzOFfH9AzNKWN3mD/Q1SjljqBc8ZNo=
X-Gm-Gg: ASbGnctb4i5NviIerAn1EJjNsaFPb1fLJq98VFmSm4hzjU/yc0ttoPgbc72inJ4HgzX
	CmDFOmhtbXGZnaJo4dv8K0brL5tM8eBLs6M6lE5NNzA4JxG8twwdA3Iqlwg9pkDXR73Pr5dQnql
	ouxJOa8SChYndcPyH3Q9P13S3jQTO0E4LiHDXTIxy9o+JhD08Tb2MQfLCYMFk6nGHzH3mbZ922g
	x1VWqOo+45zmwgutCNqX00kgNoincH2y0K2rP6zy1SIo29z/uod5MPTcHTB8uNropAufA==
X-Google-Smtp-Source: AGHT+IFXD96/9d9v41kHU9zafWGo7EMnOYJR347VJtT8t9f6J23lufIAgGzNSsFhb0F661c0jIzmDGDZIKoyqvdL+/s=
X-Received: by 2002:a05:620a:444b:b0:8b1:d8f5:6d08 with SMTP id
 af79cd13be357-8b33cfb2e18mr4654564785a.0.1764578899866; Mon, 01 Dec 2025
 00:48:19 -0800 (PST)
MIME-Version: 1.0
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org> <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
 <86c62472b5874ea2833587f1847958df@honor.com> <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
 <66c62243a510421db938235a99a242bf@honor.com>
In-Reply-To: <66c62243a510421db938235a99a242bf@honor.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 1 Dec 2025 16:48:08 +0800
X-Gm-Features: AWmQ_bmAIMkc8EuPZDlvVCWZK2eHKFHAp-DTCHKZFgBsCmsFNS3ZKYTH2Xv81G0
Message-ID: <CAGsJ_4x0aVkDf-AhhGbBLU=LCxYFqYoFL0ovij-vFEQeJ46jYQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
To: wangzicheng <wangzicheng@honor.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"david@redhat.com" <david@redhat.com>, "axelrasmussen@google.com" <axelrasmussen@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "mhocko@kernel.org" <mhocko@kernel.org>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "weixugc@google.com" <weixugc@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, wangtao <tao.wangtao@honor.com>, 
	wangzhen 00021541 <wangzhen5@honor.com>, zhongjinji 00025326 <zhongjinji@honor.com>, 
	Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 01BB6C0010
X-Rspamd-Server: rspam02
X-Stat-Signature: c8rux1hbqiywtcydctuye9rfz9xpzwha
X-Rspam-User: 
X-HE-Tag: 1764578900-404632
X-HE-Meta: U2FsdGVkX1+SGRp37egGaDCCMeLKYSrq+/4BoKgS5mi/3qxkN3YzVK0aLgbzcuFbFLxqWYmYnfCBbD01fbIXKwAeQPFk5ADtQdNn+ePAOaz25UPE246MLJTvmNFxIWE0cg0Z6eSrtHS9ZvUYSZGHSyoPH5LUYNU/Vmu7EFzY4MwgswPn0I1hc4j6DZ5RaMdRMmxKd40TCrDfxyvGUrO4oFnXMCSyX7gUUOIzGFHYuxDlKX3FTG0M2j9zg7AjTfkuH/Od97chwnBvhtIQLBatpLwe1ZC6iYBE+ZkABRK3JiavY7DCS5bI3MOtOuBzmW/iGT5vcsRPsE9L6xWw9EsoD+Ggs+/nlWKdEvagLSOERKYb2YncwJRUdSxxpLl9G7Mo+vTdG9UeoWkH9JEBbHI8HIlvt3++/UuADC/6I/W3+SRkQn9SShqkH6dKEu7zKVIUKnduxtFeyyGtsplX09+qzkPwzP69hF112fyTBCI671KfnV6yFtD9IPeVlkZ7sw9Vjr5pt/GP+QjWBOm/WYkJGm6HbYr58rrNPf2Q35wp5fRY08UfnMSHM1MOxQ0R0nYM0rYFZTIt+yLHR1hNs5eydcMOGEJIo4ESb/d8ZsLl/RwwYwniEMwW7/8v7zVB8Bb+4XjlmhTPciCXUPLSZaJRni+S2GnkoFbJRpS5z49GZrICCMkVL6o7HM/InCkRjcgbqntIcSLhQjNV+2Di/kl9zlvxOZoBly3n5d7tpHRBMASDfo9wB65VayQT6sg0XSGgWtLW/6dLYMjc8KfHTGGa4Xrj/4jkWhoRNWrxDIz+4cZqrB7GMQ7eIk++jaxkdp1lpAkMVg6KB2raw7Iebxh+Y5LyJ7saJyYY978w8Juge3jtzLD3GPqeD1N78C/CoQOhXP7zjIDVg12jRqqh9VdE7l+O7SuMniqHyJtCheKLCLwcGBjiKvVV0dOANfnmp1176mUDUpv99x6fSbo43i3
 KhcYPHuc
 Z97BCa+1CejxUdyApql8ildUChVNdOK1KnDhyrUn0qjxLtZhf7wU2NozddxdpsJLqux+kQVyNJSBy1VHHbp4ISGcr+P94yZtQAsrcZt+qWv2dmKCCZuUHOu6B9qyCIQGcoK0a48kDfiOmxGKfIXviq83szTgl8zcYOYhK7UCO7C0XIjF4oRHpSSDl2KS+kkAKrUaJ0PFu4T7mBL746D0F8QiHIHZPNpUPpVc7S+42g9Q+Q11e7Nv6fk+yJFXnLkXGGfpOtWiHRCKwMWmYuDwSqS7qn4C0zGF95E5OeYFjsjA15HvtK4WKcelw/h7SnMcQcU3ai0DyMyYlgnb6xfapPAKfLhnwy14TRWYuSjM85iyMQ4pG11xCR7L5pa4BoOBBJ98q1wWw/qT/+OamcNxgQWsql7a4VJhZeuYDtR7NGAmrQQdQtNwKugDG5iYCPMrSIlPkoQpMWdF3B8z5A3zF/AkRyLdUFJTsTN4jeiOnzmhyIha/hbacYOD2MOfV/is2TiMN3hHN1ow4adrDeN4OMC4WDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 4:14=E2=80=AFPM wangzicheng <wangzicheng@honor.com> =
wrote:
>
> >
> > I strongly recommend separating this from your patchset. Avoid includin=
g
> > unrelated changes in a single patchset.
> >
> Thank you for the clarification, separating it from our patchset makes se=
nse.
>

Also note that memcg already has an interface for proactive reclamation,
so I=E2=80=99m not certain whether your patchset can coexist with it or ext=
end
it to meet your requirements=E2=80=94which seems quite impossible to me

memory.reclaim
        A write-only nested-keyed file which exists for all cgroups.

        This is a simple interface to trigger memory reclaim in the
        target cgroup.

        Example::

          echo "1G" > memory.reclaim

        Please note that the kernel can over or under reclaim from
        the target cgroup. If less bytes are reclaimed than the
        specified amount, -EAGAIN is returned.

Thanks
Barry

