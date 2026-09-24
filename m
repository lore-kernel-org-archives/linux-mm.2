Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6466DC98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6661E6B008A; Thu, 24 Sep 2026 16:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616BC6B0092; Thu, 24 Sep 2026 16:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5059C6B0093; Thu, 24 Sep 2026 16:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AB6B6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:13:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2B8DC044B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:13:43 +0000 (UTC)
X-FDA: 85249756326.25.C35B32B
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6D1A9A000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:13:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=Rx9lsumE;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.229.205 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790280821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyy44jhEy5lmMDUm2Z3Ant0w7Ak4jDzWxPvH420aZFw=;
	b=D9lSB6OShsPf9omQ8lkXcr3Jd4z2CnFOyNXOp8RFpZUAZw39BBzBdJcs+cBBjlgaMGzO68
	cn6Zwn6YoWLJuLUsnd4FkX3+j9wWRWSob6CIvDx84wRLbgiQ1L8B4/nKmayYnpWXuQ/iXh
	b9p/WcgGB8VKnzCZ45XR5QPFzDkuLCA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=Rx9lsumE;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.229.205 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790280821;
	b=t9JOqBP/BY7AUTq9kpg6Uye/kaaSTxq7bM0MgKUuG7indiLNfqOXWMqJ6nyu2BO2Eebr3w
	YDOg67l/WorJHHqrx6UMEVSk/eauXuSz1a490P5MJGnVzOPwcUwBUz5aF88QwVBEgID/8u
	7OHlgKcrD9MqYUOviAc7nZyYU59uHKk=
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8d6489419so187575e87.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1790280819; x=1790885619; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qyy44jhEy5lmMDUm2Z3Ant0w7Ak4jDzWxPvH420aZFw=;
        b=Rx9lsumEQrPvfX17VKBVLrQe7RDdH+QpiwbjQCnX089zS8OEx64X2oamq/k2I10YK+
         e1KxPg9NzWOJMN37IwSHxLAM2IWgeLAoHqmxhxwi6hXthrH07KYOp3hrzRLIvTlyMZDd
         0PAUoY1DDXWJg0z6PXN8OUMXkRJNR9XSPyx9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790280819; x=1790885619;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qyy44jhEy5lmMDUm2Z3Ant0w7Ak4jDzWxPvH420aZFw=;
        b=Xgi9lEKvyf2nYvbt0Ccw7iXjwreh5324jBrf3z/7RoQb7QnXvRnUaoedhBHZ7TeFIN
         4ieB4wtVBb+1DVRbBHHqGIXme+LZMAgw7tA4/EbGDRuIKGwyvO5uaCiOKl4AmkZcuZRE
         P9BF3MVBJSQR9xd/DgGu7jG+ZE624I1+hdHNqgSFkq+ElnwJRO39r8gfL3yXj/nK0sxs
         CZk4jOtTll6u/IWf1QY2wuhDoCGSBZdsdVlg9QZ/JVtRB5/L7x6caruOQePBsrFajNCC
         BcrO9uKdbWdb/AbPcge9S5VM8X6VxOKbJ2iApacH73x2qFZwfHG+a2+M4lWLzYER8mr/
         Kuig==
X-Forwarded-Encrypted: i=1; AKwUvBzEUuFt7khUItnrZ58tPPZrQb0Xq4+bcHT3S7o9hF4GPGdWumSuSUAXwZI/KZdQD9eKKV9+V6T5xg==@kvack.org
X-Gm-Message-State: AFuF++krefXn1HBmwHiTCnVpljMZRdofEQesyl+wwcP8XOcs0mMVgIKg
	YxBILSl+/tKeSXxy1WujMcHT5NKtc9bnU/Gl5qATkLRs/05M2pP9KK7EuPrebjKoKomqrjLSebD
	r5FV/JL+qJQ==
X-Gm-Gg: AYBFou1Fbue2UAkUX9cc2mOc9xexfKiTKmoIHIA4ish/oeS9CnFccwYaPUoSI/HkeqJ
	5dRi36awPrjPePKvDqs/EwzEZdrXmyGBbRhoDCu/sv2iEEneEirLaeWjGiL3AgbE/X2k2+tGZ15
	3ASH0I6cSLEzsc1Tv+Wzv1Yqz3bm4rH52gGpxAAvevES9pDDd9c+Rg7kQG3uoH+OpfFRzfNF3QV
	9Qkd+HW2LFL5KGg4KVPO25cOvr9840J950Uul13gUdD+KH0TCQsS3vd+gJG/h2UAMF4yZwwvyiW
	QnfB9Qdq3su7iIw6XSZkwfmttbZU2lBkqiEIVvRpuqlN6KHDkFTraE6xWjzc6aWuPOLVea65EyQ
	lWKdCmPB9E7cPD87CABIKO3v5E7ydkHmKrdvstTQA6ZiP2hYtXhenosoJY7TSD2w/N+kp+gzLyV
	ZqASmwzK1BVvQVC2XIUAU+G2o5J8RuaBCAg2t3FBPjL8iJEjo7dzNwMkr5XQVtdCZPmXamOjmlj
	YguwpVZ5tZbLr3PvzoEKKCvhXpOOYbiIWmteDCt1HO7bLs=
X-Received: by 2002:a05:6512:3d04:b0:5b6:1883:b1ab with SMTP id 2adb3069b0e04-5b8df07ab3amr1081317e87.40.1790280819359;
        Thu, 24 Sep 2026 13:13:39 -0700 (PDT)
Received: from mail-lr2-f35.google.com (mail-lr2-f35.google.com. [74.125.230.99])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8e6ae6311sm21468e87.24.2026.09.24.13.13.39
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 13:13:39 -0700 (PDT)
Received: by mail-lr2-f35.google.com with SMTP id 38308e7fff4ca-3a64b06fc66so512691fa.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:13:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByoz18berTaFDM8QZ4Yq9r58IWaqFyTWJRypiSBWZEu5TU+r6l6r5bQWvHMOACL0L3grB4Qi3q0zA==@kvack.org
X-Received: by 2002:a17:907:94d5:b0:c26:1648:a060 with SMTP id
 a640c23a62f3a-c2ac249c6bemr320808866b.27.1790280421536; Thu, 24 Sep 2026
 13:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
 <DLFJL5U9DI6F.3QJP9YP0KX636@nvidia.com> <56e036665dbeb0a8f51d697220d5ed84f210994c@linux.dev>
 <570cf649-a8bf-4073-be71-207fbb2bef40@kernel.org>
In-Reply-To: <570cf649-a8bf-4073-be71-207fbb2bef40@kernel.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Thu, 24 Sep 2026 13:06:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh3LLDV2AMZn1PZcU1o3Na-BNcQtP=LPXouLKPZWaiRdQ@mail.gmail.com>
X-Gm-Features: AclHuK_dV8YPGJI0TEUvEYODnc_z16AdoaIsLG5kL3upeb_9xIleI71LaAxD0v0
Message-ID: <CAHk-=wh3LLDV2AMZn1PZcU1o3Na-BNcQtP=LPXouLKPZWaiRdQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated bit
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ilya Gladyshev <ilya.gladyshev@linux.dev>, Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, 
	andrew+netdev@lunn.ch, apopple@nvidia.com, artem.kuzin@huawei.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, edumazet@google.com, 
	harry.yoo@oracle.com, hramamurthy@google.com, ivgorbunov@me.com, 
	joshwash@google.com, kirill@shutemov.name, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, pfalcato@suse.de, rppt@kernel.org, surenb@google.com, 
	vbabka@suse.cz, willy@infradead.org, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6D1A9A000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4gbeu9y6jnr687cnwqh79fd9ygpeud65
X-HE-Tag: 1790280821-597373
X-HE-Meta: U2FsdGVkX19Tz1BblwDaX0yL6C0JZUSx7BPsDLJKKdYn+CURN36EQww0n9SKIisbt3f8dBJMBytxDnx7rrNjbAbIcULFjUOh4x+9GYNm0sAgKFPce+YwwTJOjBazqqJwpVRST4Mi2AOrK1NUHtpYITQGPQ5ZK4EgtnuIPE1MS92BHsZGw78UkI3hES4k+K7QjPUdWIA+BRJLDutYGOsC2LByKqHig57tiuesoj0D+NbFgbhte9jSFfpfMQ/U7Qx+tEPCa2hbAH1wsR+6IgjK9LU5Or/IYGrE+/HyrzyWiq5caiDBd74rG6PCBFo/kZb6dCuLnDncY66BvDLesYFe6WzjEyCQ0jlEN3GR+hbRXuGBdqTr8N8pu09ogV6cARiHpKjs+19zJnHZllR4CtZs2jL14S1GaHTNMe16dF/kQtqKHCGKsjcfdngm4JBrihLfkQ6v4HZJJ2Pl3C70qAtj5CqtZjVoRIH/M/+KGL4j2qFCJsOiyxXKtJqivfFMrbhtmR6ZcCAxKTnD4/D05ttWQ5Zo4QtYax3LeFSdJtHKuZKW8qzA42D00koeF3P9Z8EPRraRcoOlwG24Kb6eEZkuks1NutAyPPm0/Xijzkc4mjWl2M2sKRV7eMh5ShNicBbCfpRSsUEFnXTifFodHztD3S65xKNcdJvtrGk5fDsT5GsQ9lpGOTZ2XGwtNjzCRlLYYK9CTb6u1sh0/XXjhIgMhyr4QndTmf1gCmi7uT4iBJeAY3AYpu6O/L33JNPJjxnnW1VPYVza6yAEy6zdBMyxn2LEPl2AjpJ//UN85WI42jEF3sTH7rg6xfYfj1ApxNsWPZP/RNEhBNAnrvgZofO4j22SLEZJotheYRQlkQwn4ZMdCsaKizwua4IXCzEtVokLU4Mcfp+nEYtdBfLHYPEDXr0U/A+EYrUsg0JYimDlrpK1TdZ5bskfVGXO2NbhBtreiKpE+RwRsbuMgdcUsw0
 WaCyvsJm
 pQ02LqIIey5IoYWRwcJnl5Ialr6R9lzDF9BVX0bPc/wfvwQeMcWHlDjxOWf8h9T0fdsLlaJaA1BSW6ZyaOlcmlOSDeq9JHaWGAtt4dHjtPRpWS4ejvMvqtquavza0hKiGzaXTrK/fc39CJAvXEsuWe8WolmVVlV/N6I1LoIvIHQVeheXu3X5IWsJuE15EME1NuRFIgT73fjrnynD2JJ1fukmHQzoLfFQniHiXoda17lvhg2QZo+TZz3r5KyOp8Ax3xXo3Ty6ZLhZjJWacFDYHM7HF1VFWvJIgufZSTUtoFC6B9BluPdnGC4J/kbCCRF5aVLBz8c8hX2IFX/RPg4yDh8qtYowxtr/uyAMmiTgcJW6gU2FBHSgpypcWtuFrx7lzPAqiKI2yVMVynNM1H9ZR0ajq+gDaefHGsgWI3uaZHIZaSUY4n9sB+QLkHhfxiCTUVPgCryDPVDNVM/TvC+qkWud9kTLmWPz1Cejw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sept 2026 at 11:52, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> There needs to be a common page freeing function that dipatches stuff.

I think this all needs to be entirely generic to all pages. Agreed.
Everybody needs to do it right.

But I think that in the scenario that Ilya mentioned:

  Refcount operations as follows (FR = FROZEN):

  A: DEC 1 -> 0  [ page_ref_dec_and_test() ]
  B: INC 0 -> 1  [ folio_try_get() ] => success
  B: DEC 1 -> 0  [ page_ref_dec_and_test() ]
  B: CAS 0 -> FR [ page_ref_dec_and_test() ]
  B: * deallocates via __folio_put() *

  C: * re-allocates page *
  C: DEC 1 -> 0  [ page_ref_dec_and_test() ]
  A: CAS 0 -> FR [ page_ref_dec_and_test() ] => success
  A: * deallocates directly via free_frozen_pages() * => BUG

the big here is that the de-allocation was done not from the state of
the *page*, but from the state of who finished it off.

So that

  A: CAS 0 -> FR [ page_ref_dec_and_test() ] => success

is not a problem per se. It's a fine case of "we had one single unique
final free".

The failure is that A then goes on to do that

 "deallocates directly via free_frozen_pages"

because A mis-judged the page as having the old stale state that it
had  when *A* was using it.

IOW, I think the soluition is either:

 (a) every user of put_page_testzero(page) agrees tro do exactly the
same thing and there is no difference between how that final
"0->FROZEN" is dealt with, so it doesn't matter that A is freeing a
page that C allocated for something else

or

 (b) the CAS 0 -> FR state sequence always looks at the *page* to
decide what to do, never at the caller state (ie A will look at
whatever C wrote when it allocated the page to know how to do that
final free).

Hmm?

            Linus

