Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B93F6D715F1
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 23:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3AA66B0005; Sat, 24 Jan 2026 18:59:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8A36B0088; Sat, 24 Jan 2026 18:59:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA3E6B0089; Sat, 24 Jan 2026 18:59:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA2736B0005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 18:59:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B3F6B836A
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 23:59:36 +0000 (UTC)
X-FDA: 84368527152.21.DD0F6DE
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6A1F610000A
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 23:59:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YrwFgNOK;
	spf=pass (imf14.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769299174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=41oDX9CeFkyWVe3DgqelqlEWjcwkHQMeIKtRf379l48=;
	b=qncq2gRd15wPEkkwptb6wcWo7VrYuVKHyJibTTjVmop9ctp659JgkVFGWVdIU1NYP6swha
	Tg/za0f8RDoJ5s3EksPkHm7XHv+NA0SnV+XD5ojgaMoBdcyBpQHUqWlM0Guk30b2u6IFgu
	ZplYE5Efa7CR5nlBqxc1nZVk/9VSlM8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YrwFgNOK;
	spf=pass (imf14.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769299174; a=rsa-sha256;
	cv=none;
	b=PX0WxW6DiQL0sp8iDg8acltyg0GXM4+Im11C4iFuLsvMX1xaK1dIlK8Rgrxi0g++wVSO09
	xze3B3UxLbXciYNrFd6emFIXMt4FzD6KpLtNT/Tl9WLvQVqbgtvtQR3W3/SQL2IEogY+Cw
	XsYMzKpJvdOUWjyUwkHfAkERUc8vtfg=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a76b39587aso49025ad.0
        for <linux-mm@kvack.org>; Sat, 24 Jan 2026 15:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769299173; x=1769903973; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=41oDX9CeFkyWVe3DgqelqlEWjcwkHQMeIKtRf379l48=;
        b=YrwFgNOKTEydl2AT/daU0GbnJ6H3V4IWZufu5DDAvAxIWaHXWzpo5HPtSESi8VBAJL
         PF4c4RFYavneQ8W0stWT0XJOr0yKQqlgwanrx68zojJz3OjeB9hJdfXhN01LjLUzX98k
         mro4MWB6TVvF47FwojCvtYrWxoT55X7YbiMo+FkKBAHvZDtY0Iliesf6bsdJYTrb4QcV
         Ew2njmNsxDIyUMmp2RiEE3sVseroId5YaucdOGuJvWBSnVVLbmm31J3mLZ/Ws+pJkOLo
         sgbkej9LWB/MstkRQyALf05OiF39dsXF3WhVDdQnP5Jq/YayUpXS8PLSIc41oyU/empK
         sdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769299173; x=1769903973;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=41oDX9CeFkyWVe3DgqelqlEWjcwkHQMeIKtRf379l48=;
        b=Mi08MO6d/TRYd20iXPXmSZBZgTb1r4LNOU0ZIOc5bAhixcZ2SDnCNs1/yZVSJc2rAQ
         /tjS9gzSRMdeLTSBVAC8uQACcILjlUoshF2OJtIAFQI5ox0GIDcoOxSmO5SRFNFJ8x5V
         6ZJ9YlP9Uj7rm1x3/zYYbGZFiHxudkv64qPkH+DbShZhFXOq0/RmGPjTQXSM0VaO/rY2
         8Ea59rmAxpGE3fjoCmHNPlQUG7mI/WjPLJVFhbDgUj7+WxCnmhnqlM1TULgEMxE9zg5p
         Q93X4/JWpzdgbR1WjRKDL0MruG3S0LYhnQgqyCHOmmO517rwnEhCDsztofGq6UuRuAVb
         sc8w==
X-Gm-Message-State: AOJu0Yw8d2Ixg2F1b1mF6vY/umoVCSt35H01MRXyyBCBD7+mShTL/j3h
	tZdyGMcLWTEgjk1aAeGFfpFRF/KM4RbJpoGw6rbaekAra+V+ZlCtn3BXvxIKgDkkcg==
X-Gm-Gg: AZuq6aIuPDT0IbPzjj1zvweml4xgdH50gr3thwQGxKA10lKU1XL9sDHLBBtXCS/okZA
	xi15j+P5+NvN2dpitqEP2462ZPAvIs+rtTdcGirzrFUl7oHlM5v2Vfy3RKUI2ZWyRtlfH9QJG4B
	BrPbMBc4fn5d7PYlwqnWLvZzcACCc4fhpNbkNSFA3D4EkLMfeZ61rqhCyy6fM/wDCGX/9Svmak6
	YfRilB4tZO7XFps9nkqtY+Pjm8cU6Kp1aNt4YfXBdKugErfbwJTewcJPmj5iJni0+46Z2u3bFmz
	rW0oqLX4+3WNUGnHNd2Wcq29RLPzAJMPiI/oDRH/YnOXh/pF20+IJa/g0Ibi8gk3MkfyASUMMGl
	1WxdqKtwthdW6md5P4xB9GrkMsNPPPpSN3fkRQscYCNwKicJoAvYDgFUR9inVmhD4Unr2DX+IhR
	NN9Knw1wZ56wIqVAl0u644Nu1Y+FuFXrceMk4UvG40WzwLWJsbb9oOgD3+GExgrfNBJt8AcAJar
	8+qBtLAmxXBk4rk/cXJbNIQCxyKI0979l4hXDRueg==
X-Received: by 2002:a17:902:fc48:b0:29f:2563:7772 with SMTP id d9443c01a7336-2a844b0d351mr92865ad.8.1769299172865;
        Sat, 24 Jan 2026 15:59:32 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:817c:d8ee:c019:7966] ([2a00:79e0:2eb0:8:817c:d8ee:c019:7966])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231864489csm5606494b3a.9.2026.01.24.15.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 15:59:32 -0800 (PST)
Date: Sat, 24 Jan 2026 15:59:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, 
    James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>, 
    Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from January 12, 2026
Message-ID: <0cd54dec-4c7a-03f1-e899-a4fb14d09e23@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A1F610000A
X-Stat-Signature: p1ih88qx7spqg66ncjmhkh6mnisf5pog
X-Rspam-User: 
X-HE-Tag: 1769299174-122622
X-HE-Meta: U2FsdGVkX19E0lu9ojzGtdARYYkOfV4nec91H4bxJkUyiPqaRM5HI5ExWNQys2QxaVQSo0eZBvG8JNeFacnUgkVdrATFc6tL94jH+kB6QYLcvOPTzmvGqRCrSUa5m4G3qjnFjPYAoUlQQKWiCfmSvH1i6bJ61FzT4ib4nCI0Uj4LQmP88aUkF/1VQKhzSKyNXdfSm4kj4K/cWDg975Q4H/Kbrj5mwluv78CKO06V8TLf/UOfKwH1PLScmhwvVkVDOiPggyga7tAFJ83vN9Jg29iXNgxfDz1nt9wNzU3Sxk3gKeuCt2Rhe5YhP48DI7LdERgqc2+VOFWsn7RrqBEgrS85ouAIuoSoGDq4ZkPolL22jtpV18nlszgWI2hrWGJxIdRMWcH0niGZ4LwO32zxe9VU0pdwg/poSTWDDlCY7xpZFZapHykDQKdbfUDij5zbF4yvWZ3HbVW1+1FxsYk+PubXyXSQAlPGmZJsxWS967TV9siPkoReOpsxDBoUFiAPeFJLtObd/yNfEuKWMFkgrRCC6Cmdlb3DJrskniZrA7k/vVLXr8j6TdvSqxTRPWhMAwObxdxs6DZ3zy+Z/oZbgnfkn1ypckgcUCI0qL9fC2USVbqlnCLOeAj0zw8GbO2PwizvtXzg/gTH7kRewBrN1321B82P525+sqYae7Duef+mCEk3aa8NgX0KGEs3SHf2UkUJvWonXN5X3R8+w40+R/nNAHQhAr4I1NWkt34lo/5ptax0lVR9PNPyU1u6titd+CJwsOlpKEiDpABKHPlSKnI97ipjgKUKkaSbVZBXDyOg+H6Z1kc1PM/kXrhwksiFjwIseAeNNuvw8f8/9SbNuDcTcsm6urzybwJRFRQCDA+gElsiMHYuAWn84ncTdARKDcuuHBskgcNUfq+OX7QC7MkFsDYUtStlQ0Fpc5GlyR4U+x5RuES/g7nnZBN4pAKtAEHdCpXltxCMqdAFCUZ
 bEYEUFdY
 xcYBe1RKI98liNJy780GBcvTpbMJshODoHAqZZ0H1YKO59W9j/X62S+UAMo4eX1MQSCcXM5/+Ge4G282azJxiKL1jcxjhsnS5Zpo2wJ9zdjBKzm0mZIEsJgWNw+g3FSdLpRGO2VqK6wK+QTk4YEZgSRQsMwVgGVirVLavJ9ZdKMWHQNjBJVwLuG/tpMXVzsAQ+XDxofCob4nIeXoQXLSoLwg5R5/2o4R7EVSyhD1D9k0WbkED8UhiaaD8/Rb8vhJUSphkGo548KAsLjfKLnj0yGltnI4HNGdgW3pVqZPXR2Gl1325/fgbbqTDAxmqva83jx3BshCtVHuUDK44J7kwAddLAdAfKxSFsWd2i/tnkP1CyKTAvfZ0d3E0CPXuzVbD9Df2qIuhohquheUkDlT1Nwx0I7eX453UNqE0k7KrzqAMc/b+ZG2Cs/xw26R39GB56pL1jS4BoNJHXTQvjQHi8UJe4NKI/QLN9vNgPYhD85Fx66qN6T1GybJjD7FZP1Dt2y7cotPqLH4LriEBEYtFiXs90mD3UqvdIlA2ZblNZjTrzWpxtaf332qNax0yrCUadyBBMppGyHktBbSDVNC5bX7hdoyJgN3xZXnjNFnRp9Drpn8a/HwmLPl4JI/z//7Cblc7XIN61DkXw63HYkbhYGTZ+yqZDo5x8yMIgKJ7l1y4QL9HsV6FjMMzpUsHPs2y8MmiWN3UWaP2HplK3PSFoxbordedAVlgcz5Ebb/p8FiPERY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, January 12.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
This was a relatively short meeting due to the holidays and all of the 
fantastic discussion at LPC in Tokyo.

David Matlack discussed a follow up from the VFIO talk at LPC.  There was 
feedback that disabling interrupts on devices during live update may cause 
ordering issues so David is following up to understand it better and then 
decide the right approach to address it.

Pasha learned about other work on orphaned VMs which would be the next 
step for LUO: be able to do a seamless VM update as a stepping stone.  
This may take some companies longer to switch to an upstream 
implementation for live update given their current software stack.

It was noted that after LPC that Pratyush will continue to work on 
versioning support and memfd preservation.

Mike Rapoport noted that the videos from LPC have been posted online if 
people missed any of the sessions.

----->o-----
Pasha noted that v4 of stateless KHO was sent out last week and received 
some upstream feedback.  That series is getting better, Mike did not 
suggest any substantial concerns were present at this time.  Another KHO 
series is also upstream that moves some of the ABI to a separate header 
file.

For LUO, Pasha is working on luo-agent[1].  There was an upstream patch 
series sent out for qemu to support fd preservation using LUO, but without 
sessions.  luo-agent is anticipated to provide the sessions to VMs, so 
Pasha was speeding up the development of that: he also updated the design 
doc[2] for the work.  He was soliciting feedback from anybody who is 
interested.  There is also work underway to support LUO with CHV.

----->o-----
David Matlack updated on the status of VFIO.  His goal is to get v2 out in 
the next couple weeks, it shouldn't look much different than before.  The 
next thing on top of that would be iommufd and PCI device preservation.  
The PCI preservation doesn't yet have a solid timeline for the next 
posting as engineers are ramping up.

Samiullah noted that he sent out an RFC for IOMMU persistence that was 
presented at LPC.  His plan is to send out a non-RFC version next.  He 
also sent out a series for hitless domain replacement for Intel iommu 
driver; there was some feedback so a v2 is in progress.

Jason suggested that Intel would need to do this: Sami was going to start 
a discussion with Intel developers on that support.

----->o-----
Jason noted there was discussion from LPC about a storage box use case 
that could leverage KHO support for preserving information about the scsi 
devices so you don't need to go rediscover everything.  This may have 
overlap with the PCI preservation series if people are interested.

----->o-----
Next meeting will be on Monday, January 26 at 8am PST (UTC-8), everybody
is welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - status of stateless KHO patches from Jason Miu
 - possible ordering issues when disabling interrupts during live update
 - luo-agent development and additional LUO changes targeted for upstream
 - next version of VFIO patch series to go upstream
 - non-RFC version of the IOMMU persistence patch series
 - PCI preservation timelines
 - hitless replacement for iommu domains, collaboration with Intel
 - HugeTLB + 1GB page preservation support
 - versioning support for various components for luod to negotiate
 - later: update on status of guest_memfd support for 1GB HugeTLB pages
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update, including deferred
   struct page initialization

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://github.com/googleprodkernel/luo-agent
[2] https://tinyurl.com/luoddesign

