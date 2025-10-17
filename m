Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C09CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375188E009B; Fri, 17 Oct 2025 16:13:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 290378E0092; Fri, 17 Oct 2025 16:13:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4DC8E009B; Fri, 17 Oct 2025 16:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCE7A8E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6EFF1197B0
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:24 +0000 (UTC)
X-FDA: 84008705928.13.2CA958D
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9309D4000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760732002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owIsAlZmoRN7Gb0bvmtQ9UfqOaXeNKXLEvRKI4EdMhY=;
	b=J7hgMoplX7s5TUse4itteGcjEflz8EBu3R/SDggfIjKjqN3M3+fILyTHcVUzeIpklHmZlA
	rdv7dHhqHBr39bDrtgjG+ZwtoYQ6nESnS467sgzUw1LxIjIaq0wbjEjFJMeOHURi8lZX0q
	RMOBpNV/KgSUs2vg2MJi4JZxndRj1PI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760732002; a=rsa-sha256;
	cv=pass;
	b=Gv/gkQmYqVb98uR/e7MQrbSXx7saM63Ifkn3EsTk+xyCSEtgsTQGlvkkBFoE+sUdNIki+o
	TweBdDuBOOBj/SiTZuaOkOTCCVoahF5KWxXZr6j2iPGZ+4hSKFZefxfTx8UJIK5wo8pYYh
	d0zgxQew/bepx4L0hYClIyc/Fjs2fGc=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11CE9C0284
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:22 +0000 (UTC)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF81F1602A9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:21 +0000 (UTC)
X-FDA: 84008705802.04.7236208
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 10B0C16000F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:19 +0000 (UTC)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760732000; a=rsa-sha256;
	cv=none;
	b=GBEkXR64tYVBn1gp12AVvajU783Q1YHLtjNKn5nr+sce0LzUE0BxA/EPEfONq6t9Z2x7k0
	zo7PvYWNy6J4NG5IHWHrLY+w+h3VSuSKEnf99jnxgrMbi8Wt7x4bTw1EVR9WKGElIDDTAp
	J8BaHXEmdRCX0CFN0GisxiID6TKSmkM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m2KrgpbG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3XqPyaAsKCL0dfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3XqPyaAsKCL0dfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760732000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owIsAlZmoRN7Gb0bvmtQ9UfqOaXeNKXLEvRKI4EdMhY=;
	b=CAOG0dh7Az68B8OL8xDbG6xGnRbSK5qs9gmR+f4XCluVa/+LE7O7Y5Ct4bdUb6BrcqVSiw
	O0C4Erz3vr9ns6ZwqTOMFmf706FbW8jiixXtx3wfQYmldfRDNgS4hZHrz4r42+FTDx81+T
	LSQ2GnyZina7jCYLqaZBl0o9ClA8HRM=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc49so3732887a91.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731999; x=1761336799; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=owIsAlZmoRN7Gb0bvmtQ9UfqOaXeNKXLEvRKI4EdMhY=;
        b=m2KrgpbGB5x/2N/voJp+TCe2XmsdwRTAcxdDHQJDjqaElmIs6387N3yromIk6+r9PT
         hzKnbsIbbCTwUEYpw17zCUG9d9i2NXNPcLh+5sNT1Gx+pFmfIkWZy1C1gh4KHJeyzorm
         FBS/gp4tNQiSiO8qM/CpRtJp2rTNMn4LRECU3xIiA695w5A+MjWRPJu7XTQ7WjDgHRBb
         U6NwSFqEQlQ2HhuE/Q04slzMgi3LUeBO162aD2CghXsZQOh61vAX1kca/B89wQ4XMA1g
         K5edRUitMw/Z35zcTIJwFofa/GToL3Zw41K4CZ0XcQOePSx2zkYzQRswMHDOQCgoh6Uz
         0R7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731999; x=1761336799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=owIsAlZmoRN7Gb0bvmtQ9UfqOaXeNKXLEvRKI4EdMhY=;
        b=oFWKSpogj/5/N6t6T5p/BS6G3TeCIDqxSn8WNs7ZcqFtvS6P8lUOxlbkPPURJt1yYS
         eXX+XHchHkZ8kpYp6cucj42aSQz1YPSBLZ0+6iTes21Ghc11VxwwEcpaKDCDKNwIR6jc
         ivxp35uvQ4eMuIm6CAOhnAvFrVlpCBe5EGCR1M1fCCF5RbBPKk9cHJKMGlcYocjkBaoS
         DvnSYMh5Y+ba+R5/axIAzkHGgiA6Do8QMYMO0cKlEWvSgH+Mb7fN1Unq++DMqy4f4ic9
         yTodXDkUgouUuzIRHtjWquRwk6bs1AYAgcsyV44+pPMCuXtEBDrm+l8Q9I1Xgegc7Wd/
         zd5A==
X-Forwarded-Encrypted: i=1; AJvYcCUeh9U7qZSdfa9VyDIVoguEayuEVvLd8H6GkBXS4xdHF1UtRKXRfsVLK+AowsbFZ7tUVNEUPTHJ1g==@kvack.org
X-Gm-Message-State: AOJu0Yy/NfAzyBiwgSMwylja0SGh2dmeo1/KyS62u5opnPMpVWqyp42C
	v5IpE5Q4m+OJ3Erx8hRG/sebB3/VRlJZyIrwmbCFTq0mKq5UBmvmRVJYFA08SUeBEACgIHWY4Bl
	teRKSnweWn7+9qxRs28gTA2Lhzw==
X-Google-Smtp-Source: AGHT+IExXQGpSFTWVGWgZhk6TSzKZM0/emFdEFIF3GaH8xwLFcQEGwkRkAqkYJMl+3AP4jC8HlOrtN4AmbdSUVQ1pw==
X-Received: from pjto24.prod.google.com ([2002:a17:90a:c718:b0:33b:51fe:1a81])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e7d0:b0:32e:23c9:6f41 with SMTP id 98e67ed59e1d1-33bc9b8dd13mr6982314a91.5.1760731998604;
 Fri, 17 Oct 2025 13:13:18 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:11 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <9079cbdc091930f98948983b7e2f8b38b5a863be.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 30/37] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-HE-Meta: U2FsdGVkX19KfraHXp2jaqFXnaJ+b7Fr7LNK9RpBY6mhBuJMSAbBjX7FmQgKUSFjInMQW2Xr2/WSiu+zHKEU0wmDLA8NuOqh/tgz1ItMXNd92bmWT55Zp/b5bGbjhxhgJAy8bL0iDOxV/fF2OFlksORPJkLSONvEahBQjXpYhqaGNI4TRXAzt1uhnMsTkcBzqpwjr179wHydn4oL3TY1eV5lzBu5NHnWHeHNpu9qKKBiDfsFDqWeaqs61qfvRdsXQWcWOV+yiq3/GX4j6nDWitM/ReeUzrLhNOi+EBo9IPQSf0FzhTIc6OUWvF3mGauLAloWyCIV4wOx5g0PKgFCITnn7puracJIRVlVSLMuLylmfvJzuAjeQEsV6uPrtJmD0O+Mg9kr2eW+Za4TqnzNTnpyngXIf3b9wPqrPi1v8ETtVO5SpyvBpNuIwmTTqf5Z5bi+1POyXWouFFnmAhNmLIvkLWz/I78vYQTKk3ALgO9FpQzNDYYXtmvhiI3wdGp8Z+PCk9YWuYGpdCdO7Tf9SG9hsDT6XkAHHQJyEn0EA5vrV5IltTeer1GbguN3sqNNAUxEgcX2/C6r1DxnH4hfVBe+2+jrTdi4yvtubdLjVbdZ9sLkwMyXwkvr00jj+JZZHUfT1X4JsawNbzLyya6XdKzfdmmJ8j2yLe7sk0OAdYz7btJUEHk1rr0kf0sLIbJvqJ4uEk+nFYO4FnRx6B0Zkxuxr0kXPBXJGm+BbHYgZavzUo1a7YEOCQJQrolvqGak2TjI2kGRoGTGB2h9pdzN3vTf8uQG3D4Zp/CVtYQa8OmbBWhRgFmgUVd6MC74Pe7HbACQWtDhhQ7L4/MwVlFZC8cDnI2NHlY4uu2XQzB97lv2QkYsDHM7U3ChkOp7yk5xBHv68wwapYd3duhWNIQ9ISi2iadwp+KGB8xBjPRfcn3OU9m9ym2bjDEGdcOwpgtMNRTLg2lVuzqUQbGc/Dh
 8V55H4ln
 sM23rf6F6RPLMWaIie0G0YmsQy9aC9tAIaQWynHfKMOUZgEfAMgFfHE3fNiRedQKiIVV6Gmd7DPBIWmlPMriBZVXTml1MkNsqXbVZ73TxfxTLn2F3fywAQ5c5EE8SmqaU7ecfjLt0HR6voP1GP4ezCXz/jPPTKA10uiDtgmjYjVSlePRIKHc0kZi5Mrn50k0PDqhjm3ObkDOWXb8R7wo1Sqe2Rkcxz47n3v0WKH/6lEW4wEu4/7xap2kkUq8j0HgMxz+31eBIHPAGiD3nW/wD8uSCSJD3KpRh08NtGsZGzSH5Ex8cseiiHAvzPqS1o/5H633xv0bwi4alcXOJbQ4Vq3vJYUi/3zKd+gHp+TwTIVpiInp/ckqnDhl4EmLDcpkbA2pdvev77Hhnpsg69H1gNj4uEftdTJHZ2jC8XKSUmLnXnOtswVAV+7K6eS2z0pZ0N7Pl+Fvzxnwj95KN4R6MOmrrVSaiu7vvSzXGVhvwtQBLgTs0HFkSqN7QnSfiawHzlUSWhzquBC0tUEZXjjjXzSvnRz/OzajhmDBzOvKm9/aDDXBN3R7CP4+eowMfcEmBfdNG9u2JGRrh8l31fYr1j8xDNhYeZEqxAhPTHTKrx5AQwdtsU1t/G5ANyKt7RlGZVwVC5kO/MigcGRo4EU06520HpDhFm9JdR7M9yg3G+atqNbLANhESRKCSci6KqxYrGYgjsB3tZK5vVysyIfssFfWl0uNujJQm7xCvmsNC8g7IleQ=
X-Rspam-User: 
X-HE-Tag-Orig: 1760731999-951053
X-Rspamd-Queue-Id: 9309D4000D
X-Rspamd-Server: rspam03
X-Stat-Signature: haf9uqxtapwdb9y1jiwt4amz8fyowykn
X-HE-Tag: 1760732002-979802
X-HE-Meta: U2FsdGVkX1/W0TFPVfgRmaUgXKfoqQIyE5J0Bx/PNCYBvHjpaJv0ckJ8GneSw4yIUFr2gq+9rCxvR4Z6VP3tzdLaQkquZP9kr7/oLKFMPSLr97Dt+UO6FTwn+CwdwrR5wdSBqzKO5K1DCbX3m6Hzo8mCaQlpJmcmBAu+Y4FD+BKIe5Kq0OOMM8hbqOI1lo3tEKIrhNMBpDWiBKuX/0N4spOnkTzZMcjgw6YY0RfJZwi8suFo8pKLn4PBgy/RnDdiamY6qCMwGGUjARZm1Sh4dDw7vTTpXXDtjp7tgn9wQVAKC+pGjxJ1HTG6xBfEnL4QkXfP5DyUNG2La9m1iSEQvkp70nSGde74TWCR3HQlV+RzqSZXq2XwVOPZ+kA2erz0IBO4T9+hPQ2ge2ENnrTrf5+zjGD/AvuiHXNp0WYOkz4VIezU2OzFNdKCRsvUDN4rvUE9bWbT+FaCYzE4D8MBgb7reayygJCBtbvibMAKL+2UwoctCIAzSTMwW//qR0dOgnh0qxGrG+hWruAYMppl9AyQPk2dziwX1udlJafKkDWKoU+oSK/O0t09ylFj6iTUDgMGf8DUn8KO6oUf3FT4vp93GXQ/QaQNYsgpMoeeTPukA2N7Qc5cXXKzz/d4Gr+853yMOYznbj6sOLl7okNI8J4PGTr8BSbwhS4RuQQf+F6m6WmEcaBy0EBMZtHlhplPnKumEmH5XcJ7zfz0YafMLmz2TQ4yeGmQkjJOT9K+P03fFb1Bt2fQx4bIOIaP606QW0gX+o4oLDDRWOLMc3F8jFb8fdil+4ySnBY1NEPx8Qzw/He/aOyfVyqhgZE0ERFVUGCPhUAkC4wqh8lJhtAee3dpKc353VRCSjaxP+a3gBrRcSTssVEBN/bqxMOac45nOycbm7pqGr7xpo7N3LG6l6b+Lp8d/m1fyx/6Gw6bk7pYuQLU5Cj0wFLVlkFpFLc1h/b759q5oMgZo03O1Rw
 EXK6r94Y
 /FiFnt78EMkOf17P7Xncsz7ruceDx2z8wfKVCbMlhauUCRwQ9RZ+52+JBFYcRXCDUqPEvLZpIp37VRGVIlXWMqZ8H6tI/WM3t1NtacPiwzdRZnPqNyB3SeTNhUKX/tokeeyBsHL0nz7y67RrbYPlJN38pzbogkYeZLPrQ+jK+R5J4zI1TD6zsE/4llaHV4D5i52mrTgUet0akbWVnAS7Vyr9zjnQSeU8U1fED5wBQ3b66JTo0QlAgWatYEIfqyxindxM7rd6y+yqURpLOQ4vWBVJV57trWwNFxwgYbIfUez35GzZqOUILZ6VK/TvMfivuA3ntoPZYqpWs6q3+umcVqmmdPi4KWjC/8OjKdvsdfizwU4/rVU+U14acBrCa6C48ogHl7IruatxlEFNd641w17NwvcqfM0J3WD9HJnSakgxTrxW5kIado1PZGQtDpFgEhia3ED12NMvCOdYf7/D9HKLu+fem6qUXcFrwBIvVNOkBw/o6mrun3LUZp4Yr9hthAmUy9U+jeglKdFuXfOkVUf+SKtpXT3tJG3pTBtOjGk5c0gtUmnb+impwv033FM6IbY1ZC95+GpQn1jRpsDO7ik2i3XUlvmSTkqSY2cQKyTLaISg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new helper, kvm_gpa_to_guest_memfd(), to find the
guest_memfd-related details of a memory region that contains a given guest
physical address (GPA).

The function returns the file descriptor for the memfd, the offset into
the file that corresponds to the GPA, and the number of bytes remaining
in the region from that GPA.

kvm_gpa_to_guest_memfd() was factored out from vm_guest_mem_fallocate();
refactor vm_guest_mem_fallocate() to use the new helper.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 ++++++++++++-------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index dd26a41106fae..e9c2696770cf0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -404,6 +404,9 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
+int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, vm_paddr_t gpa, off_t *fd_offset,
+			   uint64_t *nr_bytes);
+
 #define TEST_REQUIRE_SET_MEMORY_ATTRIBUTES2()				\
 	__TEST_REQUIRE(kvm_has_cap(KVM_CAP_MEMORY_ATTRIBUTES2),		\
 		       "KVM selftests now require KVM_SET_MEMORY_ATTRIBUTES2")
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c9c59f3ecd14f..cb73566fdf153 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1244,27 +1244,19 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,
 			    bool punch_hole)
 {
 	const int mode = FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_PUNCH_HOLE : 0);
-	struct userspace_mem_region *region;
 	uint64_t end = base + size;
 	uint64_t gpa, len;
 	off_t fd_offset;
-	int ret;
+	int fd, ret;
 
 	for (gpa = base; gpa < end; gpa += len) {
-		uint64_t offset;
+		fd = kvm_gpa_to_guest_memfd(vm, gpa, &fd_offset, &len);
+		len = min(end - gpa, len);
 
-		region = userspace_mem_region_find(vm, gpa, gpa);
-		TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
-			    "Private memory region not found for GPA 0x%lx", gpa);
-
-		offset = gpa - region->region.guest_phys_addr;
-		fd_offset = region->region.guest_memfd_offset + offset;
-		len = min_t(uint64_t, end - gpa, region->region.memory_size - offset);
-
-		ret = fallocate(region->region.guest_memfd, mode, fd_offset, len);
+		ret = fallocate(fd, mode, fd_offset, len);
 		TEST_ASSERT(!ret, "fallocate() failed to %s at %lx (len = %lu), fd = %d, mode = %x, offset = %lx",
 			    punch_hole ? "punch hole" : "allocate", gpa, len,
-			    region->region.guest_memfd, mode, fd_offset);
+			    fd, mode, fd_offset);
 	}
 }
 
@@ -1673,6 +1665,22 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
 	return (void *) ((uintptr_t) region->host_alias + offset);
 }
 
+int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, vm_paddr_t gpa, off_t *fd_offset,
+			   uint64_t *nr_bytes)
+{
+	struct userspace_mem_region *region;
+	vm_paddr_t gpa_offset;
+
+	region = userspace_mem_region_find(vm, gpa, gpa);
+	TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
+		    "guest_memfd memory region not found for GPA 0x%lx", gpa);
+
+	gpa_offset = gpa - region->region.guest_phys_addr;
+	*fd_offset = region->region.guest_memfd_offset + gpa_offset;
+	*nr_bytes = region->region.memory_size - gpa_offset;
+	return region->fd;
+}
+
 /* Create an interrupt controller chip for the specified VM. */
 void vm_create_irqchip(struct kvm_vm *vm)
 {
-- 
2.51.0.858.gf9c4a03a3a-goog



