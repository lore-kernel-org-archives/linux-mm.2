Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C18A6CA600A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCBD96B00A0; Thu,  8 Oct 2026 03:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54336B00A1; Thu,  8 Oct 2026 03:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F42B6B00A2; Thu,  8 Oct 2026 03:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F03E6B00A0
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:38:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8327A04F0
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:38:35 +0000 (UTC)
X-FDA: 85298656590.09.FEEFCD6
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1EF9920005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:38:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=mUH09lgE;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=hxhlIJ34;
	spf=pass (imf03.hostedemail.com: domain of sathvika.vasireddy@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=sathvika.vasireddy@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791445113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOJu5XY2y1FzePi8hUc8AL65vLsOspAwCK8JQc1Wq9I=;
	b=P54ZXXHaLl25wNivsEkFAjwc27VVUg+QBuSdfgZheZE6NaxxecQtFTaJCBOM7irDv/UtTz
	jCcPPWvDa0V0U/N22Rb4q6kaDPk9XNs2uNLh05yK+54FMsGNfQ14RMOSduPlVca119Aqtb
	5r4+iU+/i2E8p/maFu8sszRhu+QRRMg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=mUH09lgE;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=hxhlIJ34;
	spf=pass (imf03.hostedemail.com: domain of sathvika.vasireddy@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=sathvika.vasireddy@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791445113;
	b=oLjmEKQffc/VEPVoUSwSdlgBpe7FosV6MW4HQ4MPL5eCjrZyvLPIPRiD2Wzux5g370WmRl
	6iGHlfcITpZf9OlsKqA3qGj3S6ARCtl6YrhyX1y+cUzlpQgkeC2chR/tF6sa+Gs/twD2Zb
	Nbi7hrwVTHp6K7M610ZH2/JW26PO/CA=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987K6Gn2189866
	for <linux-mm@kvack.org>; Thu, 8 Oct 2026 07:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oOJu5XY2y1FzePi8hUc8AL65vLsOspAwCK8JQc1Wq9I=; b=mUH09lgEPA5rU+zo
	NLWofU3DCVMCBdmU2hBU6YIOvsLjjT6lKQCKl5ZtWMXH9VMafn3okaV0RRlf87RQ
	RAlNUJIEm4cPa5x7lR8fKTQRzlMaE4KMldluAhIJAZbUU53UkI3vJtPU4PMo6eX0
	sw9I6OBJL931FiFpienet/FMbkdk2FAs8UikEaEgQhkPONkYh4jtyXBk0ALLxdhX
	VQWIMl81UGd4d2jf1EDND8AR/LOTyQyR5NNdYSniVZrHUH9Ho/8H7FttgCvKJQxg
	O5gGIqtSPhj+S+cKlpE7WLLDWrz+l0U0mqWODoHDOuB2xjerbXoA3agEYPyadOEI
	PDMlqw==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe39q1s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 08 Oct 2026 07:38:31 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-86f102230eeso412140b3a.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 00:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791445111; x=1792049911; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oOJu5XY2y1FzePi8hUc8AL65vLsOspAwCK8JQc1Wq9I=;
        b=hxhlIJ34x9KAIH5ZlnkGFsIaTK/TnK5AabcrfMOgGyFgkJ5x8o4Le+ZS1f6JjPGs2k
         g0SJMgwNMjvclxo+xJ2DY4Td+NEkUxw+hCWjhbRglbWKUl3AHQj0D5NLJuHd1l8CpI7I
         puyX3GrViS3iBQmnb1lFoDZrCWPIWeP8WU+GO9XFkBHssld93nd3WjcS+wbZPztM1s/H
         +HnEfxKOkMbaYi3ApLUuvu9diQa6QtmpgU2WKFjneuYKbIWD//Ed8CiPXUw7bWka0+dc
         smLkScajqtqIV2uZxuB3njiiK33G/OLiPPYu5EqzTAhEjH4QTmdAkTcLgUoDs8OJ5L6m
         OcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791445111; x=1792049911;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oOJu5XY2y1FzePi8hUc8AL65vLsOspAwCK8JQc1Wq9I=;
        b=tFLyCxTFF/rwVMelDXr4OSw96eekxwiFFvCeLF5RfELVa8L5k+1/xnMQgTgDSlLy/a
         saRig5Ycer8vFGeANrq3rjSougjMhCSid8GH5b+KR8T+z3KwQj710tJWWA0BMeDZlS9T
         gh5HHCwogVDqFVSTm3sDRJpxSqO/AHWv9po1Gl5qtrjhAxQMHLwQX1tJUgxh2sA0BV4d
         HX99zWTCbvTlI8cRFZbBGTNGkkoAookAB1cwP5b50xc1GstZOpzhpm6Uc6TFqpth5wUH
         QZ/SUPRff1o74KbPsTbBoD4XLNr1sDWOgBeOVQsIcqtP3ERHN1DEVvoQAGGJm0V3Q0F6
         55fg==
X-Forwarded-Encrypted: i=1; AKwUvBxuQ2XdVU2TFpKXHU3A4sRmt2KKnaXTv9BxNc2XLaPbZV3v4U4ENQb5YMwoOn6bDXVULG/RBGUBvQ==@kvack.org
X-Gm-Message-State: AFuF++mz4meloDUiv5hKcTrdyw613m4F9J3kZXZVlzJgpCnjEnIUVz4f
	e7TLEgX+EQON862FsvwEeefEucna7ZXNwpaV+1TGmnpgHYphLQkH40xQciHQsTPNiw7jNnSrftB
	lQbNSa9wqHgNyxy00xXUH40T8IUbkqUeeLkcGr7KBoIjCW2VRodYvFA==
X-Gm-Gg: AYBFou2+Mkn7f/AYX+I6injPlrMGFm3sivsnVZKbzk4EeB33/0LDc+kIxnoOG9mF9v9
	mDqda04GvPKY/wUj9/o7tawE+Wp5g9Z68P1uBWVzW5CIAlGBy3pQuavv20sP0kSTRsOo3q5Sw+P
	UgJwbcMpU9urWKIOpZXqw300J6J2RSjaZ6vyLidBc0H/Zh3OlyJiVbgwgJh+HZlcq1BAGW72UV/
	fo84vkOXETtrgmB+ZKfrRkvpPuNXqYAcZFekckpRzZ2bgItKbSW7qQl2Kz709uXQx1nWy0VrwiD
	7q618c+KqKe9eEbRo++/oHGSOlVm21gD/txTyR9am3exAI29QhThPYxv07sQRdhVSt62APILjFB
	QKDzJHv4XZGeaNyF/IbF0JUC1FZ1toR/L6+af7FW7uA==
X-Received: by 2002:a05:6a20:94c8:b0:3df:15f4:756e with SMTP id adf61e73a8af0-3e14a520ea6mr2795636637.1.1791445111028;
        Thu, 08 Oct 2026 00:38:31 -0700 (PDT)
X-Received: by 2002:a05:6a20:94c8:b0:3df:15f4:756e with SMTP id adf61e73a8af0-3e14a520ea6mr2795588637.1.1791445110484;
        Thu, 08 Oct 2026 00:38:30 -0700 (PDT)
Received: from [172.20.10.2] ([152.57.136.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-892bb89fb03sm1204138b3a.47.2026.10.08.00.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 00:38:29 -0700 (PDT)
Message-ID: <ac2a8f1c-295e-4791-b233-cc8549430e07@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 13:08:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 0/2] ACPI: Add support for ACPI RAS2 feature table
To: shijujose2008@gmail.com, rafael@kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, rppt@kernel.org,
        dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
        Yazen.Ghannam@amd.com, mchehab@kernel.org, ashok.raj@oss.qualcomm.com,
        sathvika.vasireddy@oss.qualcomm.com
Cc: jic23@kernel.org, linuxarm@huawei.com, rientjes@google.com,
        jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
        naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
        somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
        duenwen@google.com, gthelen@google.com, wschwartz@amperecomputing.com,
        wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
        prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
        kangkang.shen@futurewei.com, wanghuiqiang@huawei.com,
        sathvika.vasireddy@oss.qualcomm.com
References: <20260726212812.89266-1-shijujose2008@gmail.com>
Content-Language: en-US
From: Sathvika Vasireddy <sathvika.vasireddy@oss.qualcomm.com>
In-Reply-To: <20260726212812.89266-1-shijujose2008@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=J4s/fwnS c=1 sm=1 tr=0 ts=6ac74877 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=wYZPontbJtJ1d4/P/lQeJQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=NEAV23lmAAAA:8 a=pGLkceISAAAA:8
 a=EUspDBNiAAAA:8 a=ZZ33wcIyg4nDkeuy9NgA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAzMCBTYWx0ZWRfX3vC/vyoV5EzL
 yx1+1RE50+nBxCLu3i8WNLegmZgnh+o2OdMTEb2UVvkY+UquchoUYmjLyXDvZiqrKv+qPTY7r4L
 H2vKt03+aZaFtDwnSABpZANX45NBHPk=
X-Proofpoint-GUID: 7lwOTt0S5krEtazCsw7lyeWGF3UKbMxn
X-Proofpoint-ORIG-GUID: 7lwOTt0S5krEtazCsw7lyeWGF3UKbMxn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAzMCBTYWx0ZWRfX/SEqsF3gkH9t
 WKalqTx8Xon9e7T12nrTkT1FUYmX4NyvbrkJJmAXmlv/EPb/uyA2xfNX/CRjKbPYKerbOnQRP7F
 ZrQ/JhbMweOphEriEfN3Df5UHC0VgTgFG/4UymmDwN3QS+Zu1dNWL9WWrq7ZWucOpvtqPPSK4FN
 NQhJmw98NjLaRFwtrJhenOZWUFOz9RMAfTYRP3qCIZMwMv5ueAVCGbhFX/IHHZ4QYxN1vMytKjq
 f+hh5D3yHB13JhAzp6XmdRxPdIEMzJxfD93pzqVFRipdjOJtivZ2iPLcvUliryN/rmxH7w4EPzr
 jj5eRNhj+h3i6UeVMIaOkLcRGW2whGl7NDcQFs6nRdv2Z45ykJoS87QGBxXmzyCRhjqoAgdjEzM
 5Rt8D1HI0FS3yFcMExGcBNZKn5tXtNnVyTIYGjCO4aRjpkE2AI69aUmZpwrezuitzKWPOaVhy3y
 JRnHanCbLUfC0m1Lb1g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1011 lowpriorityscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080030
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1EF9920005
X-Rspam-User: 
X-Stat-Signature: ig5yhoyyx36zde87dde833qqbyg66q98
X-HE-Tag: 1791445112-704859
X-HE-Meta: U2FsdGVkX1+Ci+FtTW0EjoQcOZCKyFHqdco7JcQHi6nv6OyS08yfyMgPV9SlaCmzyiR7MXXHxBuKnJMMDvNZsUenBgLDuM2WFHviUDkfhUgiJaOOsu2m2i+vdlJ4cycrQS/WSF2rhXNastw0zidHK04kmHQSDHL1uRErQMODho/29m3RZaOOvb3iEDVVNtb01OYiiUUFQyumLWYU3cOhOSRK6YWhUcQLOt9ecocf3NQAEFgJipOLoUNpY69tkaa75eCwMV7xt7J+OWoh5M7glqZU7xjbjWsc28FmyNvl+MoNcyMbICMdCRFOGrWHuI1V3YRXVKs9a8vYTN28hUrQSU0wW4Fo69nooH/nlIbR908qrgzE+0KX/MwOt28CMZxwuMW/z6dMBEV04P8ymThhyvHcfSAdZjd8Peb67nmHMWg+SHXRWKn2FX5N9rAJlifyC8Qa0WxItUoqohb+lyXtspgHbB9emCrxkpAZErs5SHcu2t63oY3GGWXDYOxyBWH+VAnyIPJJ5mkgrivPSBiS6fR0vEx8JZ4klpEFQdAAcDTaSDLnBPcpIQCKQQ+CpqrXINHFRbPMC3ymXl124zkLegK8mYT7e5ODVaQiWDitJh1Vm99TUUENzWQBjsqg17Hj3ZdBLsNFedJWJxODqqCA1c3Oa+RtAunILkahlAfbwHPRJwzgT8Et/E43pjMVdeI0LT9uSHwzWPLceXwqW09zTEM/gZW2QxOcuMO0Nm2Z053WrnUAc61C4LfO71XobcZW9nqreC9u1OH2BalvvTIdpm4mwVl3TX8J7kAOiSr4ojoLz9ZHaZevNygVg0aGDMIl2WO7135LWqerC1l+P2LUj13M789FXvBU3slPHhO0Uf670Uv3LdclcQn0JT9XXsIQXmxP6fTLxTFeWCQhCYL3LX1UtLO07NiiTFhyDL3+7LIslzlSr5RHfI0gUIahuX5CilaY8qV2MNkJn2qmwXk
 nrzqPyjI
 pMCLeZmrZX34+hup36x76ScP2lqamAikyZuPOZHVoaqE4IwEueo+4QxXhOB6KVtK97/PguvSuIzQfHvXucX/zWZ9wLBpsCr6mnEJPwsBJDjdgl3dHOvYM5nG/U0SUdDy/ZMqT9P7hMLq4iD9JM5bTYL6JXcqY7mS0QESP+OojQbVDG9IeVzBTQ0+eJUXqkjTgN3vQC25O7mkOQZIsYiv9QI1Yu3ymJqitczo6eetFA9XfkqsvBX2j972+HLpGhD3/xW/icJyPMhCWC5IoI4YhAh4z1TJiQ7NLcMHMMCcD/+TMtpAvruGhkJxXgtF6/IhV2iTwHnb5+LJFGWN8NI22vTxTvYCBa60dkgDn8rBPn7vq0MCPXzhdisa9FSHhTzKQ505451OGcr1R9FeaEerCnPl+YIODPDjqaToQEpDiP/UqkqAcAvqXAVEtLh93llobfujRn792HK7SxLHGY9ImigL8Joxjam9Jx3FoHM2X8rFwL3Qo/flpeabgSwQV8WxIUQutuwasonnIpDbVsVnQL9I4N9lBD4vhBrCGBopLnmqO5HM2g07+Proa2PpgnfaObnJXY+fFu++rkxekmOGsFws1pEHLbW9H/vFFLpPhbr5EdLHl88JNrt4dR8CwgNDoI10kE5P/L0FRB3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shiju,

On 27-07-2026 02:58, shijujose2008@gmail.com wrote:
> From: Shiju Jose <shijujose2008@gmail.com>
> 
> Add support for ACPI RAS2 feature table (RAS2) defined in the
> ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
> scrubbing feature.
> 
> ACPI RAS2 patches were part of the EDAC series [1].
> 
> The code is based on linux.git v7.2-rc2 [2].
> 
> 1. https://lore.kernel.org/linux-cxl/20250212143654.1893-1-shiju.jose@huawei.com/
> 2. https://github.com/torvalds/linux.git
> 

[snip]

> Shiju Jose (2):
>    ACPI:RAS2: Add driver for the ACPI RAS2 feature table
>    ras: mem: Add ACPI RAS2 memory driver
> 
>   Documentation/ABI/testing/sysfs-edac-scrub |  20 +-
>   Documentation/edac/scrub.rst               |  70 +++
>   drivers/acpi/Kconfig                       |  11 +
>   drivers/acpi/Makefile                      |   1 +
>   drivers/acpi/bus.c                         |   3 +
>   drivers/acpi/ras2.c                        | 509 +++++++++++++++++
>   drivers/edac/scrub.c                       |  12 +
>   drivers/ras/Kconfig                        |  13 +
>   drivers/ras/Makefile                       |   1 +
>   drivers/ras/acpi_ras2.c                    | 624 +++++++++++++++++++++
>   include/acpi/ras2.h                        |  86 +++
>   include/linux/edac.h                       |   4 +
>   12 files changed, 1349 insertions(+), 5 deletions(-)
>   create mode 100644 drivers/acpi/ras2.c
>   create mode 100644 drivers/ras/acpi_ras2.c
>   create mode 100644 include/acpi/ras2.h
> 

I applied the v23 RAS2 series on top of Linux v7.2-rc2 and tested it.

Verified ACPI RAS2 and PCCT discovery, PCC mailbox registration, EDAC
scrub device creation, scrub capability sysfs attributes, background
scrub control, and demand scrub operations.

I also reproduced the PCC TX ticker issue reported during Ashok's review
of patch 1/2 and confirmed that the proposed fix (initializing
mbox_client.knows_txdone before pcc_mbox_request_channel()) resolves it.

Without the proposed fix:

   # d=/sys/bus/edac/devices/acpi_ras_mem0/scrub0
   # echo 0x8000000000 > $d/addr
   # echo 0x1000000 > $d/size
   # echo 1 > $d/enable_demand

   [125.577700] PCCT PCCT: Client can't run the TX ticker
   [125.577704] PCCT PCCT: Client can't run the TX ticker

After applying the proposed fix and repeating the same test, the PCC TX
ticker error was no longer observed.

Based on the above testing of the complete v23 series together with the
proposed PCC fix, feel free to add:

Tested-by: Sathvika Vasireddy <sathvika.vasireddy@oss.qualcomm.com>

Thanks,
Sathvika


