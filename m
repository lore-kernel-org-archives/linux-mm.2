Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DABD1C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99186B00A1; Fri, 18 Sep 2026 12:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49B36B00A2; Fri, 18 Sep 2026 12:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D387B6B00A3; Fri, 18 Sep 2026 12:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3E566B00A1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:38:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B18EAA0726
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:38:41 +0000 (UTC)
X-FDA: 85227441642.28.3BEE140
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf03.hostedemail.com (Postfix) with ESMTP id D7E6220002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:38:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=etiBe2vk;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789749519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ycexu/7p8mN/PXe2TLXJ60lA5nKStrY7x+9HFkGFF0w=;
	b=Yf+GrcnPXV15OVNaXo1mHW6Lr+RvDu5hviKnfyXg5fQ7BNkvKaxef+SqqHFvcc/8ECZzw/
	f9VlFeeo897C+G/chqc47jvefZOYrizzxKUn8tVWPKOt6zRO4cTsRr1eC7UCrmwQz3wtO1
	lp4ma8cxY8N5m5k1GNiV7cwJ1Rzgx0E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=etiBe2vk;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789749519;
	b=qaOFFur9YZ59rG/4qkoQEMB0GR29SF5gYESWOG3t1m+s2Ak115qDmcq4V2BADp0wNfIlqU
	4QihGBIKWeRX/X1qeYq1vQgIG6GP4hHtx1gvd7At4od3eISJBfsWUGML9wseb0teOZs4xf
	l0RT2ujfjsHDuV9AZxjy0efzAYbFH2M=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93a2a8c29c4so101490385a.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789749519; x=1790354319; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ycexu/7p8mN/PXe2TLXJ60lA5nKStrY7x+9HFkGFF0w=;
        b=etiBe2vkbj2zJ1IC0nQ7lJ4tvjnRNFPisjG9Wk9USljhebpd7HidsH5EBIAbpmcwXz
         RxEv3J2uVpEcQl/QjCLmFMtqY2N5MnRvE3PoYlGaR/9fa/BJqKNyHPXmn/183tVRugo3
         zf0WM/m6FR3tNQk+TvXijjnE3BafmG0+6B0EfL1XLNm/JxXqo8GLmXZ/EkeDwh3JjfyU
         M7Eo7LzAdvu/ksrpQ/8pDM945ogc9RYtp1f8xL8gCMDEuLxCH+RT39Hw8FTHk+x/tdBJ
         7lD94iSLTvkw8+bYKqeVpLBLNm8tD1j4WFL1zIq5Qk2Yx5FknAL0VX+lsnCMHX/BIf3v
         IbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789749519; x=1790354319;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ycexu/7p8mN/PXe2TLXJ60lA5nKStrY7x+9HFkGFF0w=;
        b=gNHv7DC4RwMlaw7xIkB7K5cISzppZxEoX9WVURxfEz5KVFC3Hdl4ydgPq7t6+uy0G6
         hgdHRDSkbNyVmwFhqj06Q4sSagL6ayCP8SVCx4+eyxmM7LDnOQ3XNqC+UJhYzY1AUFSc
         LLGmsV4XSO9s9Jwatr4LqJ5T+W0av9o5K45zXdzvNX3jJBN8pqMaQZ+6WxsRPsBotlyG
         XI2XdjWnbOMcdlmaA3acb78WHVUzrDlNAQmymKBnLFKgy5ZuFwmphDs6QF4eUvN9fXX4
         ol+Q2nxQp3izhozcxUUJ/hdRnm9tAYAprIkEQvlG6upy37u/3J+rBuNpon0+W+iZsUcX
         Uk0w==
X-Forwarded-Encrypted: i=1; AKwUvBxCh46RtcO/3SLhSqmg0DkT9rE73uLvnDu5ghlt53qjaAQmz7+/eMtGXKmGeoMDZyTO9pIBHM26qQ==@kvack.org
X-Gm-Message-State: AFuF++myllfrp3y1f6wNlbyJcjMV+yKz/9cRWFg9bJQQpbyRTimZ1uJi
	vRlbHGNOxZCEqFhYAqxlqNvG071fVgcLr+b7Cn9ng1NORgk3Mj/cvm4j6QaVqmHn1E2fcuKXpga
	4RPC6
X-Gm-Gg: AYBFou042RdJlv7Wr+TM+cQlEWZnIO3WswzTrW0H2UtceyNwxa0XF5hu+kvk9ASG7+D
	eGd3LJh9GXBgdCDP2Ehm6mjgIh8jpslrJTMSGkdiyVNfYL2ujZuoGULPBwEogkrqT1MOW3gqy/a
	Bw3gPdXsEIc2CgcXeqSq1TsJPe6CbB7YITro3jmqtmelwH4IawxN0R2RIRV+wCynOWKZG5Vh7Rr
	b5hBgX2f/7jPGVEg02cJcliYtvb6s0YJuFuKJh3J9Xh/oMewc78W7S7mSe8R45FykbylnzWTrR9
	2u1xkx7R8wahzdCoNj5b5DQm3h56lmxmGv9ncneeauKayBWdScjOJIxP7/1xYbAaymrE4T3KYB4
	l10ZZkayJojlet0WhGxwWatI7bmJPIclLFcGZk87fUpCmA6jYh2VNfNq2RV2elxEeFDD/XcIskb
	gGD56vCkZ3YvMEk4iIiXwSG6GFDr356XDtKNgAagusoS22klUAL0bvvJK62DOo9HXBhTjDA81wE
	SE8DeTFpFNWA5nBxoMHzOAy5ZDAYVuiZjUR8QSVnWHsDJX9AfuFoQY=
X-Received: by 2002:a05:620a:17a3:b0:93b:d7a2:83c8 with SMTP id af79cd13be357-93bdc8c69f5mr461480685a.55.1789749519034;
        Fri, 18 Sep 2026 09:38:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0e90276sm176813285a.21.2026.09.18.09.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:38:38 -0700 (PDT)
Date: Fri, 18 Sep 2026 12:38:36 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de, 
	hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] sched/numa: scan read-only file mappings in
 tiering mode
Message-ID: <aq1o3TYZR9JNkXXP@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-4-gourry@gourry.net>
 <0ed3ab3a-80b4-492f-867a-0584441722a9@kernel.org>
 <aq1Cwh9hNw4wWEUP@gourry-fedora-PF4VCD3F>
 <c445a20c-ae83-4571-ae97-031ce7facc45@kernel.org>
 <aq1FDhy00epXXtgd@gremlin>
 <aq1ZUTgLQfLBxn80@gourry-fedora-PF4VCD3F>
 <aq1inYWiNWtZlyoo@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq1inYWiNWtZlyoo@gremlin>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7E6220002
X-Stat-Signature: 3bmrje7ge6p9ey9scrdgnssdypat34q4
X-Rspam-User: 
X-HE-Tag: 1789749519-678217
X-HE-Meta: U2FsdGVkX19Ub6llcbIMxTzqJu9QqAcEw4+9d/h/pXro+vOkhwGiGzzhF5dmsF26RDyIOvHGkjs/uHCEVx/NC19OZryE+mJCVpYfHAiACYWoYygTcC/GFdlbWcqDRV2Eerm9OSIkq4eIAUQfgaYjQhWu5vfPEsIojTxVAb7iS6nWihli7bUrIgjlONEWV80dq9MLjAslXkLH3wTjhAupIXA8mN8oaxCypCPcr6Dh4ubw58M1js/9UQBdPTZugQOUd2QiQhzWH0Bs/C4JvySM85bT1gG5saNqWknRFHMb9DH8royoDCu4D05ExhVfKvhGF2hoX365qQFMwFUZr0j3w8CW5iTd4YrttxbLYhu9KUZYwuL7NOL0PhAXpSTdvAAmpHTVgaVcXPsOyyR8hjF9/7z474E7wSK/D7v/tawTJ/TEPowXhOm5I584tP0mUQpHNY+ii0Y+93M2Bl8pJPSdxCxTC4gJdmVJjMJv6/dnlL2F1jmuRyaNg81gYRf0jpXjKQsWiBNRUjseFqSNv27gHAe1DMLms1yUAOObj2vX1XmdQZODbj5gtvq0u2lN1TqO5Y9pX9QuW4R8UO4CyHfcYMjfBI0wU3eCNRVR7SFsd68NGdZ0kXmXaRah7Al2OiNV6cfuBU6ZhSCuVGX/5E98rvX5eoRhJd/TnK+kRhNM3opZFhJo07LIl9miubflakv8gK6BOlYR16EMpz+MFyiQjNrWV0gmUUAXtkVvxgvBzaK9ylXg9cf3Dpm8j88Z8psWcCHPURZclupy7aPQcU/inazYI4KX2s7BdOU86rNMWaSOfMH0W7EanZXfTGkj6Zyqd6YOYPibhLAiWTKLiKaqSTDGlTTyPRuiQCiGQpB5vicimp9onDZTFgMKJP0OZymC8QBE/Jtx27ujcl/EqqAuzJf7jRrSoh0LX+wCqXuEH6pLv9rorYJUv7xX9vi82zyykx/mQG88B0Z1b8Tkwfr
 LlQgyBwP
 KrXIRv5GLDl/FPaAfZHos8sCQP1MYYRbv1l8DOo7eK7T4aEaDq6HeeN6yUsYwhkTpyN5fmAmwqqVMbotDk/Xjgs/kq09UyD8+qlJ0u2wWqs+r0vFvjLxJG8gdCJUtciqk37xG/L+5rWaKKTl78KRdFH4PJnMNqBVlgUbhvcOCBqU9tJQYAKKoGyV8KI9cnVnV1S8Fg4od6LUlUHMolVunuGsdlAIbsilvrI/rxlcoNhvFwKVOqgYRJnAgHBtqr0W/OOqj7f7tNLuQpNsD6JeIW8Tu2iKguSRv/Ne1djN68jqLMgxczwJ/PBYClAnkUQqnRE1nAQcHIrG42tDkfC9N4GsT3cnr7zn8ytxE7HlCzvbOciPz6Oz6LJtVN4rIqOIxUSo2E6WKN9r+km8jChTBIPrKuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 05:19:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > Can you at least propose a patch on top that adds the cleanup you
> > suggest? Much of the VMA stuff is lost on me because I haven't had
> > the time to sit down and consume the novel.
> 
> What, literally writing the function for you wasn't enough? ;)
> 
> I can follow up on it _myself_ if you like + you nag me to (hard to keep
> track of things...) good enough? ;)
> 

Sorry i got a bit triggered by "If you check out my 40 patch series" :P

give me the weekend, i'll see what i can clean up

~Gregory

