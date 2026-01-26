Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885E6C88E4A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 05:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87AC6B0088; Mon, 26 Jan 2026 00:46:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35356B0089; Mon, 26 Jan 2026 00:46:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D2F6B008A; Mon, 26 Jan 2026 00:46:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDD766B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 00:46:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69F0D13B72F
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:46:32 +0000 (UTC)
X-FDA: 84373030224.18.C0454E5
Received: from sender4-of-o54.zoho.com (sender4-of-o54.zoho.com [136.143.188.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5D14BA0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:46:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=qj9G7zdF;
	spf=pass (imf15.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.54 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769406390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDHnzHS1RcP6v1EEhNLujRzykr8xED3y9W3aVsjVc54=;
	b=eWoOv2VFP3RI1pGOTN80IOR+ZJjfhoB3UNi1hSCSxPVaj14Rhz30UDM2954noLP/U986JP
	XyofCFcWCRzTM+vbcYZG400cCwJWm/ojkmu43ujWISDYrBA7CtqS9LbT9dh2/BODSSHkf9
	Ne2DZ35pCq/5QuAu+Wg0ehvubVGjDNk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=qj9G7zdF;
	spf=pass (imf15.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.54 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769406390; a=rsa-sha256;
	cv=pass;
	b=uFK+9VgEvTtF+hQ6Dv4H4W19QdUSB2OrYv3cdhw3PcuFT1aE+3bG1qE+z4MdNswelCzXVS
	ju/1OQbddDPMlAj1AROS+TaPKLu+9SN4syrELrmQOOhQFVlg8bj73hQvuGno35Ao4j2oxV
	VWJuWnpy2+Mkg6BxJhA0Wm2cMZ17190=
ARC-Seal: i=1; a=rsa-sha256; t=1769406371; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OCrVuxpAUP1CdhMIVJzQiNSheIz9I6Oqg+iRub1F7DNAwgt+qmZyb3EKGNqrpDwi/c1cGSKYHeHfSC05oVydNSXA7dRHFierxazNTAOx24et5gm4sLPurvncPNqgN6swV/0qvWBqbsVdcrOFrpMgWxOXK44fxSjeI03HYL/vMWY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1769406371; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=BDHnzHS1RcP6v1EEhNLujRzykr8xED3y9W3aVsjVc54=; 
	b=oKS9aMlXIq12yhElPCILGfY56fFTrdZ9l5SBO02VVQKeC1ZCVGIJQkW2UF1uIfyVF8A0S8f+AICzwHtxRPr9BQ90lNBLket8JmPXC814CxDTtBs/sQeT3FYYePQFvVMf2KuKPv7Gv8Vz9vkPKDqte2pv8LWUCjdbRdQhCGqiA+0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769406371;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-Id:Message-Id:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Reply-To;
	bh=BDHnzHS1RcP6v1EEhNLujRzykr8xED3y9W3aVsjVc54=;
	b=qj9G7zdF5y6/N/gS6K4W8s+6hmzEdwVVraEyqvvvnMYIAzmubkx7VQe8HTLmGsJz
	XOQy03VGwncKNcHeqnN11TNtv+W2Ne0XTx7hs7adTmM8l8KU8Bee0FzUz6qQ35aBUcr
	nzRlD9YMM6IPMKsTqeQSDtmjeU3dL8kpfAGDy49Q=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1769406368991212.80188119101888; Sun, 25 Jan 2026 21:46:08 -0800 (PST)
Date: Mon, 26 Jan 2026 11:16:08 +0530
From: Shardul B <shardul.b@mpiricsoftware.com>
To: <willy@infradead.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dev.jain@arm.com>, <david@kernel.org>, <janak@mpiricsoftware.com>,
	<tujinjiang@huawei.com>, <shardulsb08@gmail.com>
Message-Id: <19bf8d68cdb.ae2c0d37126486.8380742359510867201@mpiricsoftware.com>
In-Reply-To: <b2b99877afef36d9c79777846d19beeb14c81159.camel@mpiricsoftware.com>
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
	 <b2b99877afef36d9c79777846d19beeb14c81159.camel@mpiricsoftware.com>
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
MIME-Version: 1.0
Content-Type: multipart/alternative; 
	boundary="----=_Part_404629_1052231537.1769406368988"
Importance: Normal
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Stat-Signature: nw6gw47jdyicezziebqtnwo1u7k3qe16
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5D14BA0005
X-HE-Tag: 1769406390-928531
X-HE-Meta: U2FsdGVkX1/GBr75QuyZ7GUznhORxif35pQ/xHtc+KM2Wco678FfTOxm3Zt/UDjb2dvEinNKhUHUWT6Zh+BK2COQBNWm5NO8PLZ0W+dbY3PM5QDu8HwbigANuuzkPKIS1p4ERzPF6tO/7u724ryWh3q0n+kaQX0VMWCbHATw8VhyMfCZHxB7AhdHg7qtVXq2mySKbwgOuElIDQWbACC4am5T+AYyZHzC8ndQDZdmPcLh50a89OFbrCULix9ZvzNr6gQs+Rb9QwntsFmBZ+WpVRX4DQSA9NSqlRZ6i93Wt7zfdy19ugeKBPg07/UVA2Uav0yOUPhJe6hSLD1V2iiH8NrUxW1rymmNi+kYLdmX5JopMQuOPVstp0JxjznqSKlS7GMZ5gaF5dclO4RIWkCceE1AOTxM5vPzw+y1dt8MXtn/dwv6fsAofVjc+OkTh3e1xlL88NoqcEOnE+tJIpgpynO+9W9cG/cso2kUJ8ci8xKZQr38pWOq9Usvmxz1fOlzBWZsOEJBAWgDZ/BHAAJ0cDMEzF7ggwwGG1NIiz1fRORxDjD0PIfcYAKU5VGpJZBzc3114JmoRsok8APAXPzbL0RUyFXiZZ6deJMZdf2+GwRBD+Fc+Mf6tx2eIObrGcegBkJppKrVHqqD+GwLj5ukj2RH4xv/az8PFcJCHNJOvcskZs+NcroMmzIc/Gg7n/SSJE3DW5pLfjeTPGEbOrw6r9i3UuIxZbapOgclvbB51vER5bUc2/nTQJzGn0jeMHGVkVbUZ8jxZFSXMVXSuB8rTO6slXDWJ4FqUoQt+dtJxpn1ivEl++ArrIhWL9YiwJEIyrDmkQN3NkAu6KLLbHAy0MshtmWViWRU9ZiJz4EN0M71M/if34HeaKxjlyZxVHMnob6PhcY59Rf8hFs4jSkOLTBeq/aZH2givC0yyzo1n8opgQhoJqxXZPwkH0JfOAkJOIt4iG1zVhNwL9uzWSA
 15I/GJaa
 h133nbwC70zDxM258/XVjAQmIh/Cz+q66XlY+oFYXYX01ZIWTRSQ3VQAZx30Gyo63Vb1ntHoLn6C4DTAOJjo5Gn46CH1RROd+RSQ70i4C/+aq8M+OQ3TWNtynZMicb07bJw1FIwcP9qWc3jYTMygTSZ/cur5JBOsRKntFtd3RhcOxeLW8AdgjrBIf4Sd6ZF9kMrpdlo13Z9zJhl5/8n8DR/dO/9gnxTn+LNqR5dez1mIcMnpflBJwffuQRCdY/qcaZF8eRdqPSKSsDbAHN4a/HrVTxaYVd1klQWp46pAQkSxIDxDV4C3f/pd6+LBpxHLPcucBDapre/qTLFM02S6rYlRHPVvk1VkXi2Equo1yU7Hwzd0t2FfOYIOYWVBiJVSPHGtx96/IqhxadFlmO4c/gbRZ+FQDz6rZDl6oRf9LraDnS6NvHk6hbhahx8xGel491TA/JzlpZ7Dq8No2o8LVzV837PAXRpfEhKgcdWcgSdWeyz9uuy7yLu425lI5Q6PFGqJQ9czM2CFMf4xFsLH7BDnxMPBU0APXQZdgtk3he74wkzJxcTHXWAUBkdlkE29P40OWgtsW43/OxM+UgLwgpBYIW3ReKpQH+OcG2O5mL8KU/zM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------=_Part_404629_1052231537.1769406368988
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Matthew, Andrew,


Gently pinging this patch. I=E2=80=99ve checked the latest linux-next (next=
-20260123) and the akpm-unstable branches, and it doesn't appear to have be=
en picked up yet.


The patch has a Reviewed-by from David Hildenbrand and fixes a memory leak =
in the XArray library identified by syzbot.


If there are no further concerns, could you please let me know if this is q=
ueued for the next cycle?


Thanks, Shardul
------=_Part_404629_1052231537.1769406368988
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head>=
<meta content=3D"text/html;charset=3DUTF-8" http-equiv=3D"Content-Type"></h=
ead><body ><div dir=3D'auto' style=3D'font-size:10pt;font-family:Verdana,Ar=
ial,Helvetica,sans-serif;'><div id=3D"message" dir=3D"auto"><style id=3D"x_=
1889089296x-evo-theme-sheet">div.zm_1303840513312055354_parse_5216702015637=
599179 html { background-color: rgb(255, 255, 255) }
div.zm_1303840513312055354_parse_5216702015637599179 html { color: rgb(61, =
61, 61) }
div.zm_1303840513312055354_parse_5216702015637599179 a { color: rgb(107, 10=
7, 107) }
div.zm_1303840513312055354_parse_5216702015637599179 a:visited { color: rgb=
(61, 61, 61) }</style><div style=3D"" class=3D"zm_1303840513312055354_parse=
_5216702015637599179"><blockquote spellcheck=3D"false"></blockquote><div>Hi=
 Matthew, Andrew,</div><div style=3D""><br></div><div>Gently pinging this p=
atch. I=E2=80=99ve checked the latest linux-next (next-20260123) and the ak=
pm-unstable branches, and it doesn't appear to have been picked up yet.</di=
v><div style=3D""><br></div><div>The patch has a Reviewed-by from David Hil=
denbrand and fixes a memory leak in the XArray library identified by syzbot=
.</div><div style=3D""><br></div><div>If there are no further concerns, cou=
ld you please let me know if this is queued for the next cycle?</div><div s=
tyle=3D""><br></div><div>Thanks, Shardul</div><div style=3D"" class=3D"x_18=
89089296-x-evo-signature-wrapper"><span class=3D"x_1889089296-x-evo-signatu=
re" id=3D"x_1889089296none"></span></div></div></div><div id=3D"signature" =
dir=3D"auto"></div><div id=3D"content" dir=3D"auto"></div></div><br></body>=
</html>
------=_Part_404629_1052231537.1769406368988--


