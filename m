Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54847CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3818E0007; Fri, 12 Sep 2025 11:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D3A8E0002; Fri, 12 Sep 2025 11:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914C48E0007; Fri, 12 Sep 2025 11:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBC08E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:19:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AF4DC08B8
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:19:00 +0000 (UTC)
X-FDA: 83880956040.14.60FFCAB
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf27.hostedemail.com (Postfix) with ESMTP id CF09B40011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:18:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b=eSkfoqJc;
	spf=pass (imf27.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757690338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bf7wacAaZoEod1mICLvinIYs6on3YRo44Ct0fNN+0Xk=;
	b=s8gcvluwktG20vHfmeFGLPva1N0oSTIO4LzU1HDdOR39WUAz0eHhPiSYAqy3oYQPMIFZs+
	68l2sbZ7gMtJIPPRqC9BMuyIzuk47T3uG91kaefx3JLWslsT7E/qnLfi5Xaq0PTsFTHrAl
	dvlg2CU9ezzJfvs3joPX7VDKL1B3Lb0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b=eSkfoqJc;
	spf=pass (imf27.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757690338; a=rsa-sha256;
	cv=none;
	b=q8FlPy8BPUkmQY2YkBwJp1dESa9ECt6fpPrlJ6XIdNVmJdhkvcy5jb+bzeKEKj4EhAqmWn
	M7PWqNoHw867GHWv+TJQXPDvw8bGFFSmPYgi2IqkD9oZj+dHu0QJ4uAV7r9taoC4xpXR4k
	Y+urwguhFnLfCgFAxRakCkyTbG9JCeI=
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58CCWuk7008490;
	Fri, 12 Sep 2025 15:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=Bf7wacAaZoEod1mICLvinIYs6o
	n3YRo44Ct0fNN+0Xk=; b=eSkfoqJc+fqmAI7ovP6DAx4ZRLkkSZDFx/Vz4+RcRS
	ECLRXC9GMur4qpBZYifSenYYN7PzBORm+/PBkZ6nXKKTpWasNGhux2E67qfCritm
	s3/U5/vkw1FNASw7+m2etIpN0MlQzlmaVO/ygB+vKAio9Y3RGHCOVoPpmw57Cpk5
	UDeiQK8fdnnxmqb4AvzUlHfQ5nwsBQhGlSXe4pRA7+XRg7gZZnJpXEFWURC7FBbW
	vcZdAOJzdzerXVNO51MjDuODW6mWBB45JEUCcnqzAlZcDL9g4LrjbahN72YMH01s
	emfrQaY+IGsDk//woBdmW/YczAIY8w7LR85ELZpHF6RQ==
Received: from p1lg14881.it.hpe.com ([16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 494k06skrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 15:17:47 +0000 (GMT)
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id BB26A8059C2;
	Fri, 12 Sep 2025 15:17:46 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTPS id 404B180283A;
	Fri, 12 Sep 2025 15:17:41 +0000 (UTC)
Date: Fri, 12 Sep 2025 10:17:39 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: David Hildenbrand <david@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, akpm@linux-foundation.org,
        corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org,
        Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org,
        jack@suse.cz, jane.chu@oracle.com, jiaqiyan@google.com,
        joel.granados@kernel.org, laoar.shao@gmail.com,
        lorenzo.stoakes@oracle.com, mclapinski@google.com, mhocko@suse.com,
        nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
        rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
        surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/memory-failure: Disable soft offline for HugeTLB
 pages by default
Message-ID: <aMQ5kyWElcW4Z8QE@hpe.com>
References: <aMGkAI3zKlVsO0S2@hpe.com>
 <749511a8-7c57-4f97-9e49-8ebe8befe9aa@redhat.com>
 <aMMNVA9EXXHYvmKH@agluck-desk3>
 <a0e586dc-dce6-41a2-9607-f2f64b752df1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0e586dc-dce6-41a2-9607-f2f64b752df1@redhat.com>
X-Authority-Analysis: v=2.4 cv=MPtgmNZl c=1 sm=1 tr=0 ts=68c4399c cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=vR9gMrYkm2ll-U9WneIA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: RMya5ZodnjKxPHftQ2_7JMNhhPHvlRcf
X-Proofpoint-GUID: RMya5ZodnjKxPHftQ2_7JMNhhPHvlRcf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEyMDExMSBTYWx0ZWRfX/Kzh1rXW0xhq
 cDC/osAW4/J8rDGBsPPey+VIQyHYDtHHdgTNjk8chR5f6jh3wIdVPp5Ox9yVRDijIZNoEwXueL0
 DwOhZAfwyUVtp21mTqwLJSpzRJpIWk+G4aLEfYdreuSriQLCK1XcWE8ZXRyfnSdj//eRBMeZjq4
 KraDDSKgM00igYROZR5kAUSwCREMoLqzsS/sZfbbKtEKEaHGfj1LTqlj6gfstQSmfD5Nd+pH5h5
 dg3X3um5shw8NykygQAWqbe7EDLafa06s3xLAk5NihaIvWld8JLUuNPUZ98sef5L/e2G4VDwY/S
 TrkWOEHZ/A2m5NqdG0WFJ6wfAlXJNXInjrhHViALugnknKK9od+KfzF5F7W0J/wrlWuSaF+CEcM
 wVCvCvAr
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_05,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509120111
X-Rspamd-Queue-Id: CF09B40011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: cozktp8uq16738t5f5fpagi6e34gk3c9
X-HE-Tag: 1757690332-349109
X-HE-Meta: U2FsdGVkX1/s1sLja5F2tBRxHg+aSh3WSN83+5qqKWqiy0UT6RmIvrMnTVqVUowyIDKSrsEAqCxdxDifjSO10fbMNna2uEzgvzKoSAhvec0rNG/tB1WgU5lIqJNVLEEoXQuJ0di7udxcrzcDaSBxjTodnn3hD6jM3Bs9s2DkXhhejsD0QdhNaCOedZXgrw3A35M1NVXQpd2m6E7WL8Q3q2fgj55aYqCHnPp0HG9rHQDu6Cn9UiS6u1ZiS9lSFimh+23OpBASWAej4BfjMLjAswjuMPsHRSL693YpcrJp3JThA/XUvxVmmUpxe9jn5/CJIFPN8eQwF0kThNLyVAPamXvmWO/oYo5kE42wnuI34tC9xniqH54j4R9igTBVsmxJYdWtfvCmofxM989nkt9iNbFk5kFC3FF0eM8dBxdZYHE9QOO/EwVftPLhPUR6Pon2QdjDHibv6vDnh65ygFoF1pL7k3sENBs6fzgVSyTzm6dMsc8g0WNfa4/8E4b6G//RjjggoKyOXhUBD1neN5DvGxw36PQKQooYjUxHV5G/z239Is7+BEHPCqnJvdAqk627gjLnkasQNJk5pmvUeIpkJs3frBGDNSHfOsYn75jJdfxrME8UFijX09M9bchZGjZCcxJ0OnHyx6XR1Ilwtt3LmtKBuCiIaJbdGvcAAbQPTnumOTQS7bSDxR+3dvEQgnnd2jzrEdu1Gd248HoLKCdSrnDzA1meZOVmLB4lRXdr6TI17U638ChtIYkDDEtwWmEEFCFBse/dvQDkXly1o4Nh+UoMyBGDWcl9LcAhVB2eQ2hZPyLoyNpyntnwHYu1nGacnp456cPV806yiEYWRj/HQbzBZZBLkZBg2U1cDcvTanXon3nx9xauRHBauEZTJdGsc1IpeDGf5yAJd/3tf5To8RSu0C82/PG7NdRMDiVgJiVbh/BEG0F5pwdXEfzLjA7l1ZDdCp7RG1pn9U/FIaF
 N5Kuy28f
 esxx+XtLy+n2DiFxrrEXoeWd0d6SWv58X/Qttr6E06xodyDNCo8zDZ18tGJJvauzUCXEfAf2VNOhTP0sCLhxzvJxPSTTlFqeX5q2/2L+4ye1fXE0HAw9f1SPx9cWyhme3T3l+yq7GCalOkzmwhznYYEWKiwD/BHRwrNva/W6EUwJ+iYzpT7Xv4m9t0zquPuuxkx6cvY2dloDVRZdAhvb5Xcg8Z68paRvQw/veL9C7shyvycXG5z2kSLE9VBa03DrNRGqqc5amQCEvo4RhXKAzoSzDtidQK5+8VbJUkDj4M5JJjSKF+2uR29D/ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 09:53:02AM +0200, David Hildenbrand wrote:
> On 11.09.25 19:56, Luck, Tony wrote:
> > On Thu, Sep 11, 2025 at 10:46:10AM +0200, David Hildenbrand wrote:
> > > On 10.09.25 18:15, Kyle Meyer wrote:
> > > > Soft offlining a HugeTLB page reduces the available HugeTLB page pool.
> > > > Since HugeTLB pages are preallocated, reducing the available HugeTLB
> > > > page pool can cause allocation failures.
> > > > 
> > > > /proc/sys/vm/enable_soft_offline provides a sysctl interface to
> > > > disable/enable soft offline:
> > > > 
> > > > 0 - Soft offline is disabled.
> > > > 1 - Soft offline is enabled.
> > > > 
> > > > The current sysctl interface does not distinguish between HugeTLB pages
> > > > and other page types.
> > > > 
> > > > Disable soft offline for HugeTLB pages by default (1) and extend the
> > > > sysctl interface to preserve existing behavior (2):
> > > > 
> > > > 0 - Soft offline is disabled.
> > > > 1 - Soft offline is enabled (excluding HugeTLB pages).
> > > > 2 - Soft offline is enabled (including HugeTLB pages).
> > > > 
> > > > Update documentation for the sysctl interface, reference the sysctl
> > > > interface in the sysfs ABI documentation, and update HugeTLB soft
> > > > offline selftests.
> > > 
> > > I'm sure you spotted that the documentation for
> > > "/sys/devices/system/memory/soft_offline_pag" resides under "testing".
> > 
> > But that is only one of several places in the kernel that
> > feed into the page offline code.
> 
> Right, I can see one more call to soft_offline_page() from
> arch/parisc/kernel/pdt.c.
> 
> And there is memory_failure_work_func() that I missed.
> 
> So agreed that this goes beyond testing.
> 
> It caught my attention because you ended up modifying documentation residing
> in Documentation/ABI/testing/sysfs-memory-page-offline.
> 
> Reading 56374430c5dfc that Kyle pointed out is gets clearer.
> 
> So the patch motivation/idea makes sense to me.
> 
> 
> I'll note two things:
> 
> (1) The interface design is not really extensible. Imagine if we want to
> exclude yet another page type.
> 
> Can we maybe add a second interface that defines a filter for types?
> 
> Alternatively, you could use all the remaining flags as such a filter.
> 
> 0 - Soft offline is completely disabled.
> 1 - Soft offline is enabled except for manually disabled types.
> 
> Filter
> 
> 2 - disable hugetlb.
> 
> So value 3 would give you "enable all except hugetlb" etc.
> 
> We could add in the future
> 
> 4 - disable guest_memfd (just some random example)
> 
> 
> Then you
> 
> 2) Changing the semantics of the value "1"
> 
> IIUC, you are changing the semantics of value "1". It used to mean
> "SOFT_OFFLINE_ENABLED" now it is "SOFT_OFFLINE_ENABLED_SKIP_HUGETLB", which
> is a change in behavior.
> 
> If that is the case, I don't think that's okay.
> 
> 
> 2) I am not sure about changing the default. That should be an admin/
>    distro decision.

Thank you, that sounds good to me. I'll put something together.

Thanks,
Kyle Meyer

