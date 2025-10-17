Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE8ECCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301A98E0061; Fri, 17 Oct 2025 16:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2646C8E0006; Fri, 17 Oct 2025 16:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD5E8E0061; Fri, 17 Oct 2025 16:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5BFC8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA70A1DF671
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:02 +0000 (UTC)
X-FDA: 84008705004.21.98589BE
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 95A9240013
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBN6AwEHXD/aiISNDR8pg8faV6ZyO7L8ox+VpVWfPhQ=;
	b=VCZdp8gsphvGfO9TC7VpwBnpPfIzhamOHAmcVWx6GsBMD29yQ/RwIUeXQZGSLr9K/TXq8h
	KMluX55W9r3/GAlnXEBfYuKXfgXebxYoUB6sHPhQ2hv+MzlQfGTLH3zRoFgUNojLSUcxTk
	Y4RmGFoD4ZMCwHdkzYkcFbnHqO/Ze6g=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760731980; a=rsa-sha256;
	cv=pass;
	b=WrdC0yY7dSYjcBbEXjwuN0r693ubpaJ3quIofJD3vz1Ra/iRf3cjDqa/dwROPqu27NcP9t
	5zLrWEgic7mjcGRv9dI5GAVFDS8LV69gxU28nCjvE6xE6ZB77hVwSxxHPq4sN4Ld+EIpVD
	xtrGNptuYLKRrp1dL08bz+kJ8OkFXvU=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AF83C02A2
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:00 +0000 (UTC)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDABB1602A7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:59 +0000 (UTC)
X-FDA: 84008704878.27.A852371
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5B7AD100005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:58 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBN6AwEHXD/aiISNDR8pg8faV6ZyO7L8ox+VpVWfPhQ=;
	b=1Zb9YeVapVomQ21yoZu8vXUPgjiVlmoXj9E7n3bEiBZhYqgCr4LlLwksITvCUTsDlJLtFO
	ihyhklIRLu2PymROtaL/N3kqqkBzZXJl5OEKci8fRI0fCW2Q9QJXBMA2Z0aKT5HC/ZO+oY
	DhTAg/pv5bA2IAn0IQguE7JE+0r5+nc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731978; a=rsa-sha256;
	cv=none;
	b=Fo5aV7FSM7KGeNUfwcZ8hNgeCLV79KqW8so2v7L/HpkCT4MbMg2RpuiynyroXYKCFOu8PV
	mg2j0Lv/ccjw5zl4kYPH+tMpyT6NfEkezibGjYWEWUrxheJcoT5s/+O6H3WDnr+LMTMQZc
	OLlJqgySco5JfZwQBC0PWCSLGAjZH1k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=327+Gn82;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3SaPyaAsKCKgIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3SaPyaAsKCKgIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-27356178876so16886315ad.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731977; x=1761336777; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eBN6AwEHXD/aiISNDR8pg8faV6ZyO7L8ox+VpVWfPhQ=;
        b=327+Gn82q8c6mTtJx/nDs6XvSQDNys6nNSQ825yUtzN9tjo86+XW2WsmQ7gffU67RC
         tCJt50kxjYdFL8dLfFvpgf8z5XqeZYXBFBbl2imA+GbPa/mPH9s1DeZBPiRamd42n2y4
         XmUJ5aE+nVwQfE3IihucslL1VzafQMIafeuvAZ2tcXhTq5KVYHOL1KYfjVKyk9tmcHMy
         JzAKa4t8jb+GHX9LQPrYIZx2IXjMSWRVnin85fJXWs7ol6LTKeTYKHm/26beNAufLu4L
         T1cMaDL+9QpNr8e+iFHFHgbKP647715/mKEi9gt5E1YtPINMWk6M1TUzonGWm5RCgD3Q
         c4ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731977; x=1761336777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eBN6AwEHXD/aiISNDR8pg8faV6ZyO7L8ox+VpVWfPhQ=;
        b=d0j3iNyvkhDKT9ytQOsZc/I0mN7WopO/jvS7YpC4lQXu7U0d74GSvnmVP3FKbp77ug
         sbpT1VGSHrdbvZOck5npZ6j50fdA7s6VIfntBHEWmY+KPC2tC+v5WYRXI43gH/UChkes
         JF0lYIc3gBfsN8xRO5W6h96p10ggYq+MLTzDJSIMq2D2O8SwRGhcFmAtvWhLsv0Bel0t
         4VsZaWpSIcB6qH7gOzTQcV0DmTxaFz0Nv223YIi3aefUtbAcRF8LaxmL1fwLcxzy1EU9
         YLqSBieQqBK5AOw20gMEuxt6hvpoOIRKci3105aq8dV58L1gVISXg3eIkzScsutIpZSj
         3T/w==
X-Forwarded-Encrypted: i=1; AJvYcCV8j+Weug2rO7U2NQLa//7fa5AxJvnfNVmxfrdXRHR4nSFIyroQczeZ9jjHe+841dzCTT7OaZ2YJQ==@kvack.org
X-Gm-Message-State: AOJu0YzdmqQrNrgE4mo+ZqeebXRQNfpApDLf/VQZOtaIm9sUbqMCrU2P
	rcvAGcMdSr7/UB15kVzZ4e6CMJZEasOmDHR3RDLsqjBGhFnkGD2Ezhra0V3PcomjL2tMLfJd96c
	jciBS5NYtCX1DzY+uVomSCOv/9Q==
X-Google-Smtp-Source: AGHT+IGqSqDsWsx806j5fx5Gr2lF7zksRxZnbRglNYfztC6ik3n9V25acElVgVa649/iudD/hPxzJ8Jc0ivuaCEvLQ==
X-Received: from plbbf3.prod.google.com ([2002:a17:902:b903:b0:269:9358:ea3f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e944:b0:290:b14c:4f36 with SMTP id d9443c01a7336-290cba4edaemr54722075ad.31.1760731977088;
 Fri, 17 Oct 2025 13:12:57 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:58 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <8fbb93e2ffc8e4bd42f931d460a26ef9392afe4c.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 17/37] KVM: selftests: Update framework to use KVM_SET_MEMORY_ATTRIBUTES2
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
X-HE-Meta: U2FsdGVkX1+jpjIJUe5zxk/qDmh6Yfu5PMPhqVuq+hVj3luxCHXIzJrdewp5SKbc1voBjB0NI9zZm5oRcJUN9rb2VVphJRwId3A4Q8A4KAsFqCt9kFFMWp0ewNTSxQZ8ZbqwjZ6zB3uegr/DUxedS7PNpDOteDloUGo5vrsR6WpOliDtFDFwQ4UsvYpt5ZwahRo6jc0oMxYjxIlyxbvJ1NLUSNuYYzjxkeOFYBH9rWMJhRGKo1nfRWLEuQRwwTkVVnQR1OSLjdZBpozwabLk4vjaTVi03dFc7j6pSyC9fYrkmhJhLpy5NL/4pd/EmcSWGsjQG69rIWkwLeYRkCEIp14Gkw4yHwfKxb7mqTunyUWA9cWgsUFOEG3E8MZrTwajlOc6YwYBZwuNJb3dJApHYLGneyoZnQ4pI5dZSA0c+Ftem+y+hNoSP8nvjhl1IK4+xpKMzCyGSpCZimXCfzuo9y0bImakG0mApqmRTn44nMUNOsGmMsKwXB4lRtXoPdmQVo1quie9IL67eZxkt6ZANQHZiQ/kc8E7NnufrLg03v42fvRyJWVM/glTqd5mEWNAeeaG/ObeRcQsB/2ENFHDb0yku5d7E+TpiREdDRv/H2YXQN1egy1UOg0q6+p8gp/uyUxIEdM9/RtpSxgxHquKAy/ftMwtGMsFVZW+0d/8OL469Gasw7wD+NT4QaM6H4FRWC6SfoOpABKa1s/a4tybaIZMFyjJhtvQ09x93jjJgyKuTrTdIdmcCelaj2G2REz++Z2ErqhfvodhOVFgw2GB/9apSX9e2mQV5MrC1K19xjs69D125PxPblHoJS9eDBr2HFfgQXMwx0cdfkNWy4JEaoaRkIYjqxQbE/ACC+1Fi3W78R88Irg+mWmjYuibqiPv64t5bgDnSIcTQIWXJcQjLmkTFsm5ErvkQq8NBP/8VCyzKMmWIiDNfBU7mDNl6HigbodkphEw0+xeHidGKcG
 NC8Mebfy
 mQlU55jdnszyOfuLjVzxp8aPMcZLouo+j+ZBLo5f2Gc3dOKt9W+hvlnrQslIT0mEzICl71VLRbcvn/60Urlzys+KyNaBvfYmnkhLU1660E3u58Rf+fR7naYN9qmOiUgtGLco+C3uhyspxsnWny4eW46IWPA0GbC68TP1Nc1iBqF3zSBeNRPj9EMlqEPeU7los4v6SJmeEn8GU9WHp2p8Enh02Hp7IDHdfGaWG4O6CtTBtmkYYdYbU3uxqdWHqotg1QGcxcOYbR1YSLfzfmPgMV0wmXKhtZyTP/4rYz4NFpm191ZMua7siE+l3qa/lYBHHxA1ZmvVCj/ErYxOCz/odkbrQs07gRX4RJv0XNIBGkFBHV5y/hB0QmTZRfypqMTaUfOgGTNvCCVqguJj9ZPaHnhXG1IGlXR2/8dUM
X-HE-Tag-Orig: 1760731978-507794
X-Stat-Signature: jmfub8ujps9axggnfidib87pqhk9fsdb
X-Rspamd-Queue-Id: 95A9240013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760731980-921193
X-HE-Meta: U2FsdGVkX19E/WB+uGj1ICH9NHaEk87ec2SwflOeaUHwb9T9sITnD7oXXPuCfEzwQLI3Knc1ETiZBLa6AkZ5DAgs920BO7wxeV5Vave6I1mqmmpzQJ+f/oY9/ZOxsPjqYWWqaKPaCicT98hysn7qdaKX0jifv/hgE9fRkrL3r/BOOoMKII2LeXBN1HqPDyxRg6iKyQCiI/60xjyekKw6Abo222BtydgQEWJWk8I3mXsM8Y3bShLXNwdTGa9A3347ou961LUI8WTeznLwpZuZWzhGIjaErMgLEUsKUyHhqx7jVrz92zFe4YQHGWcALcAJGH8YLjY46TsPX2rZoD44mQgTJPXIisOIsnQ4PuAEt5s9mkG6oo6x/vzE5faLiH+SjWgsmGvOPPzGpTs+dcsMTj6YK6v4tljgCl/EjFLiIQ1+BSx2+miIV8aowcuPsPyAGMO3RDxmm4v+z/ZfKd4HZFEPRZM1dqPGPGM71e4eyXPXkOHmGcSkBX4nKHgP67NWxzQL7GF5WPgymHiRrvvd7rnebsY5QvEScuxrR1lI8mJQc3lSMMYikAwcv5qCOtcG1T8WWntQC319hwbJ55Fb+UD1sGagw/l9GE5rgHFtmo5OOavhCodkEwLK8QMJtiGkpDIDdxFa72JD7lDb8hAesxbDpWjveeYSap9dk7bxwbP+Hv4Ws5AkSvbUPvrOb/P+UMORiIZ/RwjCkvFUeNoUUNvR832yOvptqTZKQ4ij64Vm1UukwvrhTJwfaXDjoSqQNb7JtSYORs/Bkcqdf6+E1UPHaEOEi0MZzELK7krQXxyTTzU8fVlo/1s1/zEka7xeNQgk/WHbgRGdfarjynXkFgw6m1QHjMuWp9HbJrhqhPHSpoZJ8Zzzrlx/JBIVztoz3yhW23CdI/buF2je7IIU8PKMncjXi4K5J2N7OjoMYWa++JuDbmqJfmmiW55+0TNtS/hdv69+o02YitKMfdS
 quV3OMQ3
 NxCAorHyK3pP0hL4bbKehBOlom4Ji5Vy8LcIyA8frafVycrl1Nwlwv4JLbWL0ta63gXL1BcC7sNxxw7fsqRHqchkZlcG6eoH25JA2hXJazeiQjMmW026d9hXfoK3kzh/7DJKLPMS3GJB936iUsxWlgPT0h3PRJ0rONqPQ91Zb/0QCbu8dvLZSUfY9KlDxyn5VKmZsMCVzzJNXM6/pVT4w7sZFQo6t4mosDgFK3HnlDNcfd/55Pv+91Y69FqvV+epkk+wK/rc21jwReWqhpAN9R1EvdY40EO3PAzFC/JlwPau7BUAzFlgSDK2VA1OsoBcGmY7mV2mrIEGXY5Un+ohRSXkoGWZ0Ry5S4iz1LrlPeelGxNPnhTmKVLxMyf/c5IKg7yv8m7zMZgzuFU7lT4+DxAkdJcnKKpCwn4m2WmRmmNmPiuH02EV49raQvqrrNXqnMN7rrypZxLs0S+V6ddyRnMI0rU/hKwHEzJg6xaM16hAmRoHKkmMvJMu3DTm7gdK92pvjQh8/3gfPu50RnD9WjSiAuRbOManqbkvAM9EHKfYYdIrxCeGMSiZ4swp4q2iZvk1Oj3RHMMJM2XM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update KVM selftest framework to use KVM_SET_MEMORY_ATTRIBUTES2 and the
accompanying struct kvm_memory_attributes2.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index de8ae9be19067..019ffcec4510f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -394,24 +394,30 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
+#define TEST_REQUIRE_SET_MEMORY_ATTRIBUTES2()				\
+	__TEST_REQUIRE(kvm_has_cap(KVM_CAP_MEMORY_ATTRIBUTES2),		\
+		       "KVM selftests now require KVM_SET_MEMORY_ATTRIBUTES2")
+
 static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 					    uint64_t size, uint64_t attributes)
 {
-	struct kvm_memory_attributes attr = {
+	struct kvm_memory_attributes2 attr = {
 		.attributes = attributes,
 		.address = gpa,
 		.size = size,
 		.flags = 0,
 	};
 
+	TEST_REQUIRE_SET_MEMORY_ATTRIBUTES2();
+
 	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
+	 * KVM_SET_MEMORY_ATTRIBUTES2 overwrites _all_ attributes.  These flows
 	 * need significant enhancements to support multiple attributes.
 	 */
 	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
 		    "Update me to support multiple attributes!");
 
-	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
+	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
 }
 
 
-- 
2.51.0.858.gf9c4a03a3a-goog



