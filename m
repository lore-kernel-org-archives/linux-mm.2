Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB66BCCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72DC18E009D; Fri, 17 Oct 2025 16:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E248E0092; Fri, 17 Oct 2025 16:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468A38E009D; Fri, 17 Oct 2025 16:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1221B8E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCBC21DF816
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:26 +0000 (UTC)
X-FDA: 84008706012.11.8872CF8
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf17.hostedemail.com (Postfix) with ESMTP id 96D2C4000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760732004; a=rsa-sha256;
	cv=pass;
	b=BBJ/EGtvAD70oYZD8hfig/HRPaot+hCCVsPvu/j0YtUfkad1+6NO7vuaJBrT1SpocB+0Rj
	QM4EP2tUZpkWCkC+letpbkcQXNg5+IoRexkIQR6aJIweGK/KN3po5OrbKnV0RMqpIWq/1L
	SgsWzj5KKQ7lEXqbHnfGVX2OzBc4AsQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760732004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orndpBTxP9JNgsL+ZAOMK9xM6Hxdzt16XLD7BCy6nI0=;
	b=ZUoUVnoEuZTYgzQsgIej0AgRmfOl/Y4+RoW9w6coZCijRdToDSogtImixYtw4Rab37XdsI
	l1fYVASpgcSCpyzGA+NzPum3friNdrLCeItwzkUC013JC2dl2YNHte7QjADh7tud7EohKb
	ypPNaWd8V5DQbsCBpaMJO8kaE0wBVGg=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EDF11402EB
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:24 +0000 (UTC)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00F201402E3
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:23 +0000 (UTC)
X-FDA: 84008705928.23.D4BC228
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id A2EB914000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:21 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760732002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orndpBTxP9JNgsL+ZAOMK9xM6Hxdzt16XLD7BCy6nI0=;
	b=o7/21lJcmpwvMnIRBK+OwOFE0h0rTSoHupny1po457G9MP2fLI1DM/al0Qc32Da4gJmz3k
	oOAyikuzEHjjqSftTBRIPzyrdbVabLg/YjezaozdasTCX1YoACWXoeSMCvarJ9krIMNv3U
	xeVoJB70fOMh9hxHurt+nhSJL0r5SvY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3ECljKrX;
	spf=pass (imf26.hostedemail.com: domain of 3YKPyaAsKCL8fhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3YKPyaAsKCL8fhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760732002; a=rsa-sha256;
	cv=none;
	b=0cRKDWZtcIameWMtxqMYUT/HYbbQ7ftTL58vuH7TVExvhjfh8ShdIE7zbp1iGep42aquA7
	d1AoK44ZTB96XPTBTyFtOAnaCp8weOspq7SbFoBYnMjgy+a5FoxyWiOZ+K8edpg+/tlB7t
	3fvUz3Mw80c+IEPBJc2hn4ZlNn2inOw=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so2009278a91.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760732000; x=1761336800; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=orndpBTxP9JNgsL+ZAOMK9xM6Hxdzt16XLD7BCy6nI0=;
        b=3ECljKrXHJdfIKV/u1Ocs2Wh61M/qLX6y9zxcGAvv/03ejDJK0GW40UFSBPl2j2hnf
         5KKayHewZtXW2p0ulBTiPbG6ROPNPb0ILV567r0g7HYRn4r3SoFwp0ipvD/Zb7N09OgO
         +SwUZBpOC5ttmLOsQYmb5eqtwhXxD6aEbzDp0fkRg2F2VW2hjq1gYH58YUrl+2+humKk
         SIFgquJG3MbgugemqmcU2cyBRG99OqoKue/c0Z+nF2eUNfFOYg4h2/+CzsFw5abl+uni
         ji4sPxqkmZNkyhLJuVN3EOzuECQyxzfyOYbDbBN/ZsBA/sAr70YGrgcQ17gNDbHfXFYy
         XRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760732000; x=1761336800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=orndpBTxP9JNgsL+ZAOMK9xM6Hxdzt16XLD7BCy6nI0=;
        b=kG8KoFWDX8EP/g8QSWE2Oz0SCp/oLxvZqaG+Yd9IoxTxWtcwsJhTIMplJ+nljykxRx
         4uilAhB7QCSpqYh3Cwb4nA4NuttzYh2eO+UzqhujsJuM8R1I1AbfejEo9MveMTLRLwve
         y45XvXEBVmkdYXLoUDZt2SBghDPvk77GHEY4Ja9XpnSvuVKNpq1kYYavr66tjnFQjKBg
         qzZW4X1OU7DZ4O5V8z0UuIztGDRdy7KU4ZN2A+DEJJlZeoFOmlScYekuqPZlmmB4HnYa
         Sw6K79/nxMtHrHyXkMZ5AgjYcEgbf8W5eBJhWtfRnml+LAqD8FImvk2tp2eysZeXtET5
         yOXw==
X-Forwarded-Encrypted: i=1; AJvYcCUyYu0tO1YnuFGOIYWbSlZu8x3t9ZbCiokgqWlscDXym2TQTu8aBJ8jy1jgBNpH5cYY+HYIpb/IDA==@kvack.org
X-Gm-Message-State: AOJu0YzDKrTBvY04kc4mzXog8i0SO36Mi+iod3HBxUn+tUzn/yFVdwgJ
	uXlV/gGTRK4TECSs5m0Ekn9By6MG3MG79ECFxex3PYcVia2JhSGPk+DYpK+/6A8LmgvjL9ZT/xL
	xfPT5vM9ea0JeLx3lFl0c0Bqssg==
X-Google-Smtp-Source: AGHT+IGeWtAhjkWefmdEnHuUzNA6r2JixiN55bt8CNgXz5dhA+P7k5CcuR+ogb7zE+Vv1FAI4nVZ4b3YH8H7OkxqhQ==
X-Received: from pjbft18.prod.google.com ([2002:a17:90b:f92:b0:33b:dbe2:7682])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2690:b0:33b:a5d8:f1b8 with SMTP id 98e67ed59e1d1-33bcf86ce26mr5766621a91.15.1760732000433;
 Fri, 17 Oct 2025 13:13:20 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:12 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <e1e189b70461a6bf0cb8e71c1a18e0f9b553fee2.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 31/37] KVM: selftests: Provide common function to set
 memory attributes
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
X-HE-Meta: U2FsdGVkX1/E8bXLWP4YOo5cyfrNV0C9TSlzBYHBDLEhdWMxE+uDp6InA7y4/eLMEAu75MVCmS9EsLphVsb1teXmz63B8zRN/g3vHNldR69B3yM0KHLnsDCcskgyZ6VHdk+OfoHsKlEcrrHrR1bFKz6qn0x6GmOkJw2OA+iSdwxwdkmBW0dCjNOl3tYDTdncu90I4FkQLfpoMPzc6lao+6sdK6kaWXBoj/6pURpAXn4jPc1fJoY8a22CwRmmtQMbZkWstM1LFlEL/NdsRo8pRqOorTxzHPc7PfYXrM4li/PLRk1l4VLvAaWwwwGKXONBLY49Xj4rALCzlQkISayGWAkr98imF4pHKW6sFgCOaPOHmbE/3BlVw3pIHJYIdV7gprTWukaDo4+v5P77A7tCUdouiWNC+ziO0vzLW/cfHxbo3WafbmYfTNFXj2xrTguSmsxrOH85hRHjyBPfMSAdEGEvq53U1tpZ5O6dWKbnQ/74V3miLE08yxnzY9C6fSBIp8tUnNmd9o9eLZG2CV5UF0h2N9FXvsGOKZ6qPhwB3FRKnVtW+te3/bgMLGwo3P5d3+YAKMSpdXatXoUS87kgELXU+t+u2Rm9Y8hKN2JtiIDqlgVdneLxflvrC4hF2CqOxzYiw7/0zP/xC+8I/F7RwMg0TU4mmvY3v25U51tTON6eFN3r6fZBAu+ejYHzUocJGd5dYpGYHY5/eJBNFcR0DPjglORVhlrpAOB0xYZighWoRxqT1zekeWaJObaNTLhS1SHT5m30JJ/44EJ25XYHCxYjPmPV63Wq/cmzxVNU38XxJxphBcWat2VLrJDB7IybSQ9uYtKwSmkKUAChbS802iH/SYVkef4ljiWeWbnFwh3JbJZpRqjJwiRtBiAP8eeo5yk3+Q1CtslhQnucaP4PqBiuLqpLq8oh4BKZadUIiveAQr3tURsD6ixmCSIYTmrRAniSHOyH3UWqoom7LQ7
 fJiY85tW
 OFlcfDI+tKFeNRuu1/IEi/vZCEAfaIWWDCxlHWBC9ZK3EwlAefgFwjDsCzikGfsAlZwcgyjsiuAOqNyFpA4IYUOsj8YH+ckBJbjj+b26eIDAhTapKnZld0lONJ9rHixqeyxP0sFI5qoprl5CHqFa3LE81EHd6kwge70sKh5rQkolvWb/7asD9WolQTMTrM6vfbHRiE1CWrHDhLSX0Y6tu1WesMbmS/xjeG/FL6xIBzpcNcU8qjx5cF1I8vr5WtzPTZFTWBV1MdTbaLUMSFcgFzBIrUgA348EO7TZZi7MhK2p2WlAwhGn3Ilxs8qTCOwWfXmBtT6lSKgmzqEglzZOMcuGjmkCHtnXeLX0kT3Y6K0n7bZZbx5fN6dWLa0W+CyntxYsC03QrqtWxKG1xOJx6T1Sqh15vI++WD5V6+R1NuGFuqO2CZ0paxg/oRdRjyO3cHI/M7/Skvgng3q5C6QcSXYmsO49yfi81Ukvnl55OjbDM1NSLSAPzt9pJgdFzhlhuV4Oroyp2YM/Cy/SK8xjIFOsHV533IBdLD8on4hfvmydi3ZjCSRjQ7kdhNWQViDz2GRlX5kG0wap8YKCsxcsslMmnK1Uka71vx6yciBrgIgLC4i+np9E5Ww5FSonTl8ygDXpt4UVGj8VxamE4yWCzm20sST1bzi2t+xT9LNX/y0OsX1e2jQ7PxeHf/g==
X-Stat-Signature: 7bjwm3674mzbm86chyr4ustw64hrdwd9
X-Rspamd-Queue-Id: 96D2C4000A
X-Rspamd-Server: rspam06
X-HE-Tag-Orig: 1760732001-346883
X-Rspam-User: 
X-HE-Tag: 1760732004-144743
X-HE-Meta: U2FsdGVkX1/Z4Pu9FmtVVrX8jc9E78ZjPfPW/0voWVT6fBJJwAZ1enJNAnZJ3IACfYJ6ApwmO3WOobX7paGO+OQJ5BpPs05Q67Tv3bBI9TOC94G/FR+NK+SgVDMoKs1//DmXPNpkJKVzRIqgYk24PI1ozCGfuF+RCNanXyyxFgC0bt5W3QhoS3JNpBmMYTv3wGIskBXY7Xo/JW18t5+EvnB8cW6s+7iMGVohgPysizy4q5Ia8L5zj5otK4ai42TRDDq7fNqI+JQqkP3gQgoO3r6AnqFkB6AigqM/75qbzGd1kTtA3bIZqmMAwFZ/LPnl1Z6nYA5JKv+SA32kb5ST5icffWfONih1grk90SzgpWzR3FYH1Xn7LEIRt2OhkUC5toP8NnCRTjQjJxpDale8zrYqNXAugDwiH29wYdHPUltJhCpgfWrJeQwY+nSDI2DFJ4J+FbwTDSqtSnKejfkr5A77TTGnmdye16yFZW6w6XRtoWf9AmST9Khjj4VQdnhZI9gdgxwKjfuwjtqTwyNP63bhbnZyb3m0kcsavDunlfDA2a1G/10nbt5XFec7wIirk9mtE2qRCqjXjBXEF8oVeDwQHj1r84UXNUJ8wksSY8BOnOhWXyufnFBC3YCTnesz69oApF+NXwC09d4RMsYGej1WKsULBUzMcFqz2vsETrJrpKZL1xvsQ10Gz47CC5aV0pBq7oGXxvXGoAXutmHWXy7oLRw4Yy2A/eSPvo1luIQab68aTE4AvVxNWw8ym6Rr4SOuTZPWKoonTZm+Wzs5UIkXtAWvSd4MHMfJN/Cn7+eBn34SzkRR6x3apPOmfXRECiZIyEq/b3x7apPKnY0BHBgCFMpa/qCVSduVWUE3/1i7HvySo2ONfwHph0R5/dNQXRdQDxzDPLP2Xla0lnUXV7DMOvMSS48qKeKjrS+/OVWzMwS+VyGGmBZDPajPVHQF2IoOocZ72gTnHk8KLb0
 vz+8I0ws
 71lwTaZYXMewD4WOMbwHOoz3GbBvoeMwhGTEid/oVNFp3h5LcOC77wI11o7QO9UGOnkRhoNJeIICdQDHT+MrVBi0gCkicIYFiHTuzpROmaQQ2E0Njro+KZZ1knZ8DgNwpwHdXP7LrKyURNAr3NqgkfvQtxdPU71J5JdQ0AjV3H/B1ULkAMcal/GvhmtUeQmvfRaQ6seYLhlDKIEJYGZksD7JNXVyfoTmsuf68aU/uG8IemqSSxahh9D6QnGiDztChyIk8r1qmb11DLtOX5wqqQ0TJrnp3IxgsKnNjJ0nY3eSk/UGySsozEM0lmDDwXHIbiFKdShir1sGJEW8Kd0w9HYw5Al2h7IbWpMIJ16ChGs0MSQLoqAgnAagdnJVKNSwWH6m0n/Pn6K1M8CFAxmTR5zJHkJveBtb13pP9fm2a6WDIfVt4BrUsKGpf+lU+nMwdpbQtBMcj0eFKNvocuYZ00CiPVFqsqEo1wv9xfu3lq/Okowk+XF7H6z/1+MT0jnplSiajBtBMEdRpzCjB1OPy5LUUu0bIBs9ZSn4ZyplnOFrcIDeOmmwrxG3kMHkzg9jdiALs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Introduce vm_mem_set_memory_attributes(), which handles setting of memory
attributes for a range of guest physical addresses, regardless of whether
the attributes should be set via guest_memfd or via the memory attributes
at the VM level.

Refactor existing vm_mem_set_{shared,private} functions to use the new
function.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 44 ++++++++++++++-----
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index e9c2696770cf0..9f5338bd82b24 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -435,18 +435,6 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
 }
 
-static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
-				      uint64_t size)
-{
-	vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
-}
-
-static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
-				     uint64_t size)
-{
-	vm_set_memory_attributes(vm, gpa, size, 0);
-}
-
 static inline int __gmem_set_memory_attributes(int fd, loff_t offset,
 					       uint64_t size,
 					       uint64_t attributes,
@@ -507,6 +495,38 @@ static inline void gmem_set_shared(int fd, loff_t offset, uint64_t size)
 	gmem_set_memory_attributes(fd, offset, size, 0);
 }
 
+static inline void vm_mem_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
+						uint64_t size, uint64_t attrs)
+{
+	if (kvm_has_gmem_attributes) {
+		uint64_t end = gpa + size;
+		uint64_t addr, len;
+		off_t fd_offset;
+		int fd;
+
+		for (addr = gpa; addr < end; addr += len) {
+			fd = kvm_gpa_to_guest_memfd(vm, gpa, &fd_offset, &len);
+			len = min(end - addr, len);
+
+			gmem_set_memory_attributes(fd, fd_offset, len, attrs);
+		}
+	} else {
+		vm_set_memory_attributes(vm, gpa, size, attrs);
+	}
+}
+
+static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
+				      uint64_t size)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
+				     uint64_t size)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size, 0);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t size,
 			    bool punch_hole);
 
-- 
2.51.0.858.gf9c4a03a3a-goog



