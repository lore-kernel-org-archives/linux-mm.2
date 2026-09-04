Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC046C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 17:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC91C6B0096; Fri,  4 Sep 2026 13:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FD96B0098; Fri,  4 Sep 2026 13:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E536B0099; Fri,  4 Sep 2026 13:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B478F6B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:33:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54FE98014C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:33:49 +0000 (UTC)
X-FDA: 85176777378.26.76449DC
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf05.hostedemail.com (Postfix) with ESMTP id 66D93100002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:33:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Rfk7MqYe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of stevensd@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788543227;
	b=NF8O5+rf+g5XM0Py9J00buQux26wNedUbSIxDFOjIIDQQ0cegj/J6Ij6vNFqgyBIwz3eXw
	+kf6i9/z+g+JkSHzW6RvzQjxsXBXngt0VmY31q69cww59WvY48z4YY7l4Xu99jwvyIW67t
	iOaTmCYGWmlwI1ckV1/1nzyEwP9/1BI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Rfk7MqYe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of stevensd@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788543227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1ktVxTbJlW2upQFhjIfSwuMOl5963W4/r7K4+ZZ0GY=;
	b=A9xT4ElG/iNI9RfbOJdSkOcKTxZLbYW+lksEjrHF/4t4mA6l+faJqferDlQtocj6KAQNFA
	Xg2sw+FonU2V1xgO+J9vsMw1sgeUrh+V2kIjwDUgyAClzS5poep+I3V8gnRVQCF5gVseh4
	yx76uB2n1eVFC+7I2Ocb5RZD2Yzy1q4=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cff3b3b92so21095e9.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 10:33:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788543226; cv=none;
        d=google.com; s=arc-20260327;
        b=n268f7uqdIq6o4iGyNueYwycVQnxznNoR84a8lx0NuhiuqZJ+YKx1qbCVxf6yeHDK7
         w1kdZ+QYzYNaUDXS3rU0rWPhXGD8a7c1B5u4Jt5PzSVR6yP/u+OnhGBrCB83KOoUBhAD
         o17f8qm53jmIv3xxUoaV7+/V5I1rGZ69iS8d8JyeQKKbCBcmHGDpKeirfcIv/YWO/dAk
         /XLDSAhPyYWRufjQTHhAhHEPMjhsveV5iPftolsXbLe5IoyTtgSXSghb8FcRwXlHT96k
         KBIgbxHXO9zczH8AvoR2f2+HHweIUMhcuYBzSZWXaskTZGLSvKX3YLLOjmnXoIP2bEZz
         4ZHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t1ktVxTbJlW2upQFhjIfSwuMOl5963W4/r7K4+ZZ0GY=;
        fh=zxvXFzJevY2BbcuyC0VpriHQZ9+Rh9c4t/9sry+CegE=;
        b=eI1y3UqWWAAVN6Rdlo9xlGbfBKZZHqJjuPWvByleVUFHEf7hPW4mUVHt3W0bbPn1f3
         9ATpW1CQ6zOpvv3+tNhGEmKJALRPHJfHRuk2vtAFFgzGEazQL8nfaKLXe/soFEjw5y6u
         1Dh/HlxxsXszSSijmlWwtGg8Xj4HdCRgOQPWiaBqDDOi345rS2UaSgF2HJalxkf53JNS
         r3Vtjiu/inf+GyTHR74P41G/M55powPKI8HAiUcdG/inOnh8MQ0kG0oBuCyNDdqupr5o
         +p6hGIH1oH9a9Hc8h19wN58rUU16tUP+V9VI1RCOjuadBYX+lxztTMnJqYnQqjR1YRWa
         H44Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788543226; x=1789148026; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t1ktVxTbJlW2upQFhjIfSwuMOl5963W4/r7K4+ZZ0GY=;
        b=Rfk7MqYeT/uUs0TaRdzBUYsQqJmiIpxRcECq3lYQvFqpkGL7EH0ZVuPAmLjIXuB5Wo
         K3n85tUWuAvPdhD7VekAtMUCexQjT3NiHCcX6lg+EZBHjT7AftPlIY4LXvG7PUBlvJGC
         bqd39bDtqpSI8CpyCPObo5XN/PxQ5r3uSHkJeyYkI7rY1Z8jXNsSbtTgtAb0Jl8UCvyN
         2xp3YXbnO1dTL5CbBbSvWtySx5pr5VWrl7jA/rAd9XhGnCD94eOOZrsZk8OIFoIuXxlE
         NPo0ltxg5uqzm8TvY3z4io8DMTj/eHIkoEUAFFsKJ8uIfsVoVpiOPME6bYsmNscYgKws
         xUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788543226; x=1789148026;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t1ktVxTbJlW2upQFhjIfSwuMOl5963W4/r7K4+ZZ0GY=;
        b=Dn183I5REp3vmegvA9ev1Fu1V18uOXMG6/oYMV+wK2OdTKWNIRu2wAFhyrIXGYn+oS
         tUbnP68B+h2KxmEzCencUXlCLK15vRqy4s63ab5HyDMMKVkBUG2VGRC2jvZHeqS+6WFj
         HtkBmsNii0E/K42QLVlS0NCf2lpGeJ8Bwkmy2lykF7tCNqRKvae/rFtbAleK4bPRq9mx
         qd99US1leGPeQSOhs8L6NQMGuFZhoV5YO8ex7LCRhImJZYMXHMUY6eRQPLfEPccoF/2+
         gzJyLSbcx0EKuutNlZyA2zY+cCOIvDPOcZVNQT6cM70p8/AeHAp/j3mvmTgjPcDWOM1u
         c7FA==
X-Forwarded-Encrypted: i=1; AKwUvBz+Jrpo3boTLphnzDJgAZkTdI1No/vFSMUNN6R++AWz/ufQHlUzr4jjZIbEECB3DCUFwo4zTH6XHw==@kvack.org
X-Gm-Message-State: AFuF++kimpLSiA5t3utRK+5wC3pHlb6MYrYhrW17X4HQPIsQMtYcYd3Y
	fo5iIJbOnFh5ga9aW+pVaqJmpAWJ5M5pSp1iJ/KOgyBfkXX9TtbZSWVLRBJp1esTkD9QFWYPlAM
	kLJULEsPKGnfsVd4ReYqyR4u2Z87t5AX0tUif+JfJOtcVPbDMwSB4vflU
X-Gm-Gg: AYBFou33NafdOtDlORICt59yQnqHokW6Tnx95quS+IHNer7guhL1T8ftiXmdAzgdVtn
	Ce6xpOfB2+zCipmE1CwRv4UvDzMTY15nBsaLGiHjyuSrT1+4fa5A5b0LKUNcajo3XGV0IfBjvej
	q1KboihdFVFccCDiiDT8Pbhw/C6UgJuv4Vetv+1frzx3e3UFUghCNXdP3/eEJQgbO2c8yayhite
	4GiaXXuyg9n66+YZwZPq0C3qjSkCAv5zDcH0eN0mNygpIR9xIh6FpLt+rwPbe/mnQ7VJe0rUTdw
	6Jq5o2Dn65CliNkLpVQickcgeGMKSAmbExMVBUs4BQf3/JTyV0b68t0BHUJkDY8c3ij7a4uDlZu
	z+Qh191G0Clo=
X-Received: by 2002:a05:600c:35d0:b0:499:fa56:f542 with SMTP id
 5b1f17b1804b1-49d01d85e40mr39325e9.8.1788543225025; Fri, 04 Sep 2026 10:33:45
 -0700 (PDT)
MIME-Version: 1.0
References: <20260831234339.280376-1-stevensd@google.com> <aprp6GXv8poXXad9@gremlin>
In-Reply-To: <aprp6GXv8poXXad9@gremlin>
From: David Stevens <stevensd@google.com>
Date: Fri, 4 Sep 2026 10:33:32 -0700
X-Gm-Features: AcwNN1W259iSlNcdOxCm33dP0lK-4S0p3PqWOSOPP-wtwD-84kHw7ZoHOPqUqY4
Message-ID: <CAOiLmNEPw_cPE0QM1Q7CbNC8owW94PvejKo71Hb7DF=QKNN4Lg@mail.gmail.com>
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is allowed
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 66D93100002
X-Stat-Signature: h17x1g5w3t9naycoh4cpmezxiirz3nt5
X-Rspam-User: 
X-HE-Tag: 1788543227-685241
X-HE-Meta: U2FsdGVkX1//OLq9t9xUpkhV1To8iaN98kygTa3Dx1oTkuxMB9q7tPOC8y8OmocSfmyO5P67rIMNKICJQOpXFwWylPWWCj+WWj3dZsOWIuEsaAKT4LnLPWON8Ir2kXsy+fCSOhkRelT3gqeM2LUZlSV+MTtCcPdueTAwQMlqFsdc5kbObfXhEJnJgvhif9V1OYGKSYBOTNYAV83bWAjPCC80GAPbmR4neE9jEjGiFHdiEziAFn48DTMoeJcOYOsPoDaULlSEcS7SNZJOu8EZ9TnTEqQSk/+AFavlOj6NqzuC4VqxZh5NbwLjf7Luu8x85ZX+fi7eCVwS4cGl0U3kcjwRmH9LdCES+CSb2IRwbO1OL5RjMSfKB+roIYzGX8GoE6X7BjoTUrKUBF2VlcZNIU7tebmzdsJc09aWHNQaOfQYKT0RtyarZ9vu/J7xoAHrzTux2CuGKm/jknwqxBMtS7L1VIUxwVjnnnU3g9t8wlYi8UPzFEQNII0nAd5i/dmir0u9AWF2ToWy51OWVfGtm6t2+op0hiDldYZ16ZRwp5wDFXrWgmhHiMaLcNnVb3NdlYjzvdworRIyzP9e51BT82EOr7H4Z4B2RVk9gAc0t13NQkwSifCAv2EHVdC3lv++6MC28O8KJZhMNeU1OTMpCJDf0HgDHUDX/Z0SzNN6i1ts1QUfiukpnCIK9OCeIGAfe+hCrXKISPGYuQhehfBcm3nSfTm7K9azDazstfYlIl6RjBrEF2jBSyVgizczgNC5rrpUl+HF7g+iDveRR8zR9slkvLyEPwywOLA01jbgQodvLl/mZm04JNb//t4Zk+qZXZ/H6gDzsgxuVxRDBQ4++U25kwYjXr6lpZHjVuX/CGufFTwkwLbSBZZboiIGg5FhRhrKFnUl5RCOLERIgHIXBgLk6eOK5mn/ZgyB6dPeq8v5NwyEZey0dtBYHxEK0EGCgOIGXht4l6OyMUwA+3h
 uA3xPY2c
 sfYWMyyoa06jQrM3RjqMq8WT6QxHPheTcajAOINztfGtYA5kT6G7ssKNJaNkFa4DecsMSqAnYf83A4RTeu/cTuFs/BNgtPeS4UJVx0tsTHlTg1HOrB6vO6y5YVAKggJ8Zbl52QMm51GLFWLegaRETKzs+kkTHjOHed7Qq4gHYi6MsDU3u5er0U+EjQuWgt4JyCRKbzM8FTtdeVlh/ze5B1YxMMVPhcZ/j87EMam/bJj8FE3npiekm2otuqiA+zqMlN16zuIzO8zffAd1rWM6Xz6ahqYCsS9nGbC7yuYldfgCGgTvEffcJf9r7VhQsce2rVUNJ98kJD5LsII8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 9:25=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > Memcg charging can be done from any context, but calling schedule_work(=
)
> > isn't safe from an NMI. If memory.high is breached from a context where
> > spinning isn't allowed, use irq_work to schedule the reclaim work.
> >
> > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > Signed-off-by: David Stevens <stevensd@google.com>
>
> This is in mm-unstable and breaks the build for me :)
>
> In general - please don't rely on implicit header includes, if you're usi=
ng
> functions from a header that's not included, add the include because your=
 local
> config might happen to import it but another one might be broken.

Sorry about that, I'll be sure to be more careful in the future. I've
sent out a v2 with the missing includes.

-David

