Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0445C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8746B00A6; Tue, 30 Jun 2026 18:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A0E6B00A8; Tue, 30 Jun 2026 18:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61A76B00A9; Tue, 30 Jun 2026 18:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1866B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:47:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B34E1C5C5C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:47:37 +0000 (UTC)
X-FDA: 84938067354.27.4CFEEAC
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1CC4A10000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:47:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=VwJqzYBE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.176 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782859655;
	b=NJqNk6wcISkLLpN79dIimwJHS+h5BV1jwCU343NIClukMz2X6v9no5Mcds22qsP0IGzuPN
	Svt/nPtcLT4oO2rlngxMaeLLt4pFrKSpbfmEYrmodDW34FlXkX20jYrGl/AX5l+piV0eW5
	NCq5XTofAxJHGrez2GGsXRhP2l+LxOk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782859655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6XSzlODMBAjsxii22kyfJpxbWcVK88QpVIVbQAF0ec=;
	b=YIS6WqLf3vPDUalpWZT9oppmCb/0GxyksXUfIbAJwxXvX4yuvHXQrW6gHJPy7ChrQsZ/qk
	7Vy0W+fiQdbcQmBZcFUPUPPd10g4fteMdv++76rTFRbDh/nzzAwQ0KiwQhc0OMW50NbCHF
	xI2iWXJdx3yUOe0Un2GoETg9lHC+Aa0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=VwJqzYBE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.176 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84236f9b638so16179b3a.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:47:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782859654; cv=none;
        d=google.com; s=arc-20260327;
        b=NHmiRFQnC/x82k92Hvy8G1Imqb4iFgrfAH1h4uJO5CwDejdn8I0QNP/2h4iFvrjc4r
         ccBxE0YRlFAe+ytRseZ50Zb/faMNVUDsNdHEMmRtsMnH5lHpC4p2zy4m3Puvhmc++TyX
         /UmXxoyXSdxiuhRA9Kio8ioUjUbnm1JdZqKN7B4HRHVrjMOuicVzluspb59gT+Uj6Oa4
         R3A+/OsUsGTUWrpLnEfgDn+YUfMnW4bsHdtqDWFWfaU96I4uUUVpCIlr0KYhSRk7Q//h
         eNGN3NlfdnjhI23avWOki4aHQwrU23k/qfMckXqCSxaU5WxL5KVkpPWg0WGWgsotmd4F
         OEDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q6XSzlODMBAjsxii22kyfJpxbWcVK88QpVIVbQAF0ec=;
        fh=X97bj3NfySvO55qsDQkevXO7zZDpElZMaUVWhrLYlEo=;
        b=ez8Vf2kKHEIs/ESu/pq1vymzhwuT8o2ybaZcKhyPZfPzxrLxEfddG4JocPv3Xdf4AC
         w260zfYx59D271WIoy1PT/fFizg1F9QY2HtAL0+/mPTGW3Eo/uEUUiZ42GDYG9XrE/ZK
         7+648yxb2MeCDb3pn9AfgioU2QEwiZjp1109dXsBYEtuYZatk4r/bizs7Y7Neml/ALoy
         kiv0nT/CFGWFHcoxVlQC/U+v9pPn7ysfNd8x052JLEWOWZhB3gEX1dbnRBM/Te2J8ppT
         pnj4L/heLK7IAPdP2WbOFxwQFiWdqzxGO0r+1u4ALzXST0hEma3N8tV6qVx8EPprTxlv
         BtpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782859654; x=1783464454; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q6XSzlODMBAjsxii22kyfJpxbWcVK88QpVIVbQAF0ec=;
        b=VwJqzYBE7BaZ6kSic9JYBPFqiypVNrhbkmQMChNK/mDREiktx2UZa0aknrfGj9IHQC
         OovqSslohX4UsjEwElMiafu3euzvvo0Ls1s/JLyIA0d4Rm59Ng1EFLGYowLMfY7NQKKb
         yIpT2fdukoi3piEJwf6+3nuRMQ07fe2SJX7CyS+PWKhqp99sK2gpJGXwexeOFUVa8Jbh
         29mb/CmF0sDHOkw0eK/V4+a1ZL4dVB6EzDIjK8yo8Db4MqS/t50vV57X5qnQZmtJX+z8
         +qXELb5yYVowEB8tP5KeTRPyh6FbPA/mKuU0Ib069bALdOCisP4pS19fkC+eKQbipFh2
         tBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782859654; x=1783464454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q6XSzlODMBAjsxii22kyfJpxbWcVK88QpVIVbQAF0ec=;
        b=oOO4ByOHnyC8l9iFXA8NgDj78IozgoHc42OBjdyb1CF95KEGtqixbScFBd6BI2HUq0
         4MBNATtAZu4QXPFUKPy4rBxCzE9/cfu7lTlsTZ0/PupIluQBO0LIbtfJ5kdtnP0Fp8oo
         wlUNeVOoWYD591Bz9pM9DhIBCNA5h7Mh7YcpDntw8w9CFLvEZ0+v++6OLmg8Qyzu/MIR
         mP36Cg2ttl1mhp3FeG27ruz2ikoL80DQRE7JRiiCzbpTn014jfWhY4DoyaTJW2iuoQL5
         V5/uZyk8cMptJvtPf76NuRS1xdppGbRfM3SEiGe8iYTrG3ts48yPaSkerkF3G5HkwwJ3
         CPyg==
X-Forwarded-Encrypted: i=1; AHgh+RoIeD7QXkqQpfMQzVUD7WNQn3nfwCcLKzgVVd6y4HAGKWeZ5EZeRyEqxp0fTiIQ2ykKwqhxjjGNsQ==@kvack.org
X-Gm-Message-State: AOJu0YxbhUz+5ZkrBC7hZNcxugmn5aWjneEzKgDMSUpeXi76p8Lcgxx1
	3VPMCcXnhlp1SSsa2NZy2D1NRk8D1qMSCUzQZ4lT5jrzKM1I3UdWdKsyV54AFbGpQ2eLK8kT5N9
	syZidmTqa2w+97ljWBl4jN5EBWCn2KnHGhhiDy623
X-Gm-Gg: AfdE7ck9bKton7GeTDwN/pnIwH7UW0Jz+Mei/RBy/eryNa6GVAd7DdBA9TN6/nBuRXF
	uL8kRYFzvQWvtCCojC2X/ZsVn2YBsiPvVVPn+00XI2lwZnJikoYszbxg2A6ZXUMru6rngpNRUkr
	eoijArfPl1FLxBvHgv5ya18RqhnJdV+9gVpy03+nmQJPDIn9oM4iBl/6qqN3r8JO+fs+oPuad1h
	i00TGBdnzL8Bvw15Mv0uVFB3gTQyScUfkBkHXfBVvy1RnYVJUkaCKLpxa7AhDLb3dpkFruJI69T
	7CyiOK65OiKsu7OtQUkSC6tY99Z/
X-Received: by 2002:a05:6a00:3391:b0:847:8f0d:cc0a with SMTP id
 d2e1a72fcca58-847aded7b04mr2110834b3a.41.1782859653990; Tue, 30 Jun 2026
 15:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260629214712.1198680-1-xmei5@asu.edu> <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
 <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com> <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
 <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com> <CAPpSM+QVOwhmwspjaUg+FqKsHjiEn7C+gYPEcpJ_UZA=JMj7zw@mail.gmail.com>
 <cb547653-0ed0-4fc5-b022-6f0b9691a4c7@intel.com> <86e805c9-ede0-473c-b8a4-8b20439eaa6b@zytor.com>
In-Reply-To: <86e805c9-ede0-473c-b8a4-8b20439eaa6b@zytor.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 30 Jun 2026 15:47:23 -0700
X-Gm-Features: AVVi8CfeTyAqMwW0h6OqLBV8Qm96A-JxdAHG7H4hcBAlPYhnz7GZ-EseQDFaFaY
Message-ID: <CAPpSM+TM6VL36XAoDMsoCr6u+c0feab8DzXuahjpNfVJQ7g2JA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>, 
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, Yan Shoshitaishvili <yans@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1CC4A10000C
X-Stat-Signature: 7f77s434yj516qugmth67x955wpgphyz
X-HE-Tag: 1782859654-187565
X-HE-Meta: U2FsdGVkX184WlTNsqJ+scncSpZsIoUI9uHkbmJUM4GAtcfTXUoifxIds/MhmGlQi98QZgSDhYun+BVfBpEhV/A5LK7ex8SHe2M9kzzxuLKRB+RZeOg/p75jOstbalIuz98Q8YWf/SnqM4nAGSZ4VHZEubq+Bo6KoTTtqf8fzLfhV+WMH/DaFpCeTc+cehcsIffufZAGY1CY5Rc1bjgEfFSvO6Dmmf6g4WlzYJxOi564uXU9weCIh1yh2SvLGfrldnQFXnFumUXoz8YMZ7wAkB36AAP0L3KY53NnJkx686xRAR5yndU47VJ0wxlQdzND5gbnNJE4uf4z/PO62HDwnNLaR4KW/g9aDSOmLZ3v/VB3fM4OK32MLajJeRUsaAIfuTRsO2LpQwVJBLLO6wi5Na/a7NB96r6q48hA8VbG6k1IlWofqaH7IdSPGqbFaoxmckNGyeeWJwnWqEy41efdffp5RBYwYoAYTzjUmbdTozsCRiabGZO+LXah+oyoginpa3M/kJ9gUCloOlRYFoL6yFkh6kKZUiiWW0yucdODuA+g5d7MwmKrGao0rgU82a67fVhwjfCdf5g/B24SWc6S4SBqiA43d+kWfUEqzAJlga/o9GrTkL0xy0Lz0Z1iTcH5tXXb6yEQmt80Ieh8LFfdd7Mtet46ULra9g0H58WIarl5qY3R0pNaTu7EKZfdaQHxMuX4WoZ26zy8dIeA4i2sMgpQ3UpvuFe4LziSMgKzzYsKEAxYtJZL5CyWVcSURBhlt3T9XdIhfqvt0fNMAuKN5D2FfvB6ifTKT47/HJA7Xp29d/Tj/1cDeczKOhUuF9Rhr2kDEqWLKkO9O9tEJx7SrHZ4OZne3jJg48n02JnQcVo+Xasb67I41nNhnZTujg1D1rCV3TRTvtfR0MeTtJGaMsUoYK+qZ24/51NoeE3aBZ6QrQ5HOUA+kytB/nwMNGTr+B/Sjv1kRyMy+0799IS
 pJyBXHEN
 z9FrlraDsEMinTdAljkqJZWvi5I3J1yCpUVbjzQgWDWTQ2S4ucnwsxXUfyvG96ZtuaujIZ2Tr61s1gezI7wmOdxt6GcGgJcLMOdTy7sVTrDvPMtoayzpIlDoI8JYXpfz5kf/kJfl09nkcV1XYrI65pm0qUqUI5Dx62YJQkBWlWjHOOgyx+EqdOYkuOg2XEyrv06UVxY2Pphmz2+Sar1TzQbyZlAIOivNrXn1X51j8y0ZZLi/11npxVvSnA/scyBOC3k+7kqiwO2CFP5v3f+4pZC6xs2XQ+sIWP+IU4KMx6TLVz97zJ6v4ZRPrvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 3:14=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrot=
e:
>
> On 2026-06-30 15:05, Dave Hansen wrote:
> > On 6/30/26 15:02, Xiang Mei wrote:
> >> Please feel free to ask any questions; I am glad to help.
> >
> > How do the CET features: kernel IBT and the (theoretical for Linux)
> > kernel shadow stacks impact the situation?
>
> CET should prevent this from being the target of a JOP attack.
>
You are right; CET breaks the assumption that this technique needs a
CFH primitive.

> Kernel shadow stacks should prevent most stack-pivot attacks in general.

For the shadow stack, I didn't examine the implementation to check if
the working stack can be surrounded by attackers' payload (vmalloc
pages). If yes, the shadow stack can't stop this technique, assuming
we got a CFH from a function pointer in a heap object.

>
>         -hpa
>

