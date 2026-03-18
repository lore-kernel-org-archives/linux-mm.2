Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4413D1088E50
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 23:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9206B0383; Wed, 18 Mar 2026 19:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A126B0385; Wed, 18 Mar 2026 19:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661E26B0386; Wed, 18 Mar 2026 19:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2046B0383
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:22:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10C331397B5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:22:40 +0000 (UTC)
X-FDA: 84560760480.12.19E8619
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id E5181180004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:22:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WgpdScz7;
	dkim=pass header.d=iesbenitoperezarmas-es.20230601.gappssmtp.com header.s=20230601 header.b=ytbfbJG9
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773876158;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g+WjZKnwu30ebrQom+i3UsD/eXl5hhXeYFa/T0bSCTQ=;
	b=Kba9m4LwzV+ejWwBfAPmO3/mBcEEgp2f8sVoXmdK2MpcNYAGZKhLftfBedmRwTN2nbZPv8
	WqPuLZRx2hW62j/60YEt2ujVf8dtpPRQIek+CmplvUP5PtXopYDdbplwvlRTvB1T6nKd5P
	kzOXbW90aWeihznnp6m+d65IxueeQtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773876158; a=rsa-sha256;
	cv=none;
	b=EnP0l/p9EmMYyRdD2aoL4MlGLrLRWCZ7Y1r3qqHAA1oW7pmSc4bJGg9zWmeeF9saPd17t+
	6P736SwGNEUbufauYb9ke78CqEhdQG5D5OHqr8KCVn1MaYo2Nr0arYLLgOhiwIdlH3ZUTP
	eFcie2SESo/vNEQfxBUd07W1Q6tXmHo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WgpdScz7;
	dkim=pass header.d=iesbenitoperezarmas-es.20230601.gappssmtp.com header.s=20230601 header.b=ytbfbJG9;
	spf=none (imf16.hostedemail.com: domain of marcos.deleon@iesbenitoperezarmas.es has no SPF policy when checking 209.85.128.74) smtp.mailfrom=marcos.deleon@iesbenitoperezarmas.es;
	dmarc=none
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so5604045e9.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773876156; x=1774480956; darn=kvack.org;
        h=to:from:subject:date:message-id:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g+WjZKnwu30ebrQom+i3UsD/eXl5hhXeYFa/T0bSCTQ=;
        b=WgpdScz7CjpmSUWAEiPuJyUjYs0fpjdLKG+LUhUm+TWOnkWQ7OWmXdhNfq0nnf/pDy
         +3JcmaO2QZh5WL8/x3t915kjJlYlGYSsyOmGJxld6uVbhecEKNgmIUMetljuG+Q6ANJ8
         +0QqbNjmX01u1z4yWBOv+RTPqDqV3yNgtBhxkUMFM8dDuM8ON1Tp/J4H5Pj0Sh8HFRJk
         2yGQwb5K0+2533TI3sQe02Ne4LNz5EQxiszPJzY0ugAkxbm42cNKUepZ4bxVG2GKx4kz
         j726QKdDb9Wo/0DT0g7j6pvhyBiigQQi9yzH4U5v1Cla25mhvMwioi99b/PjkpGwyljD
         PcyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesbenitoperezarmas-es.20230601.gappssmtp.com; s=20230601; t=1773876156; x=1774480956; darn=kvack.org;
        h=to:from:subject:date:message-id:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g+WjZKnwu30ebrQom+i3UsD/eXl5hhXeYFa/T0bSCTQ=;
        b=ytbfbJG9HhUkcPqOmsPY66uqzxrbdIsQNefxgYl/p4viQ/flCvP4qikN/eP9N59VrT
         ojjHVFF8Kofi6Os0cKiFqdHFc5RS2zFl+YhwbrJjKEt9nfb66EhKJsmmTtOD2s+bfROb
         sz9DqGKm+iIf+gDYrn2Gj+ylQOFYGoEARuBODOXSAW7XWSc5V8ktkvMTQaJJJQgjSaRQ
         DpLJlWf7ctD5D7TkxxuPDIrFc22KIMaEqmkrJKA4IgFOxYHnnvLa+mYHYqYJg6qGeOU3
         01kgIoddiWP36VthzH2WcGTvylQhLJOh0/3/hHrhJxf+3l3YFGKXGGi9dtGfrJfCkV3w
         GmZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773876156; x=1774480956;
        h=to:from:subject:date:message-id:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+WjZKnwu30ebrQom+i3UsD/eXl5hhXeYFa/T0bSCTQ=;
        b=kL4el0AdL8vD/C8OcovRrEI4QnoZeIyblkqXDAp5Rkart0lY0bqLfGQIdyNtStwT2z
         I+g4yw8VF1Q5abCj+pzxWi5pE5S1QDFx/Euy+CDWsm0WHk0IE8cvdpHcQtvBDOuV00t+
         alnyAJXOFpbYWn5/J6PsicRqYbzzMtr4qyo26o3J5gfWlpvAoAKQVI9lsqHLTbty+wn8
         CwYpRxMjI+UoXD1CTCO168ljNoZrcLUFCO6InaUovgFkiPhTGCfRWYZ86uIuU1E2bS3y
         nz6IwTkGFGAldJ3aLEZQpbSk/3HC/qHjkrOFFyHEhMPXAOKixu5G4CtUxJ6akPbqMW/0
         Vl5A==
X-Gm-Message-State: AOJu0YzX4ej1U6k9OEdodFGorl31RMz7mCny7DbOxopTs/1OoxFhGKrX
	XpI59pIH7F+HmzCo60mBmXsifYzC+uOABDxhQCEGhA/mEF7mG4xqZFETuad6pJVRU0dzOq4f3p3
	1joX8wQcUd4lqQXouEx5ej+bomyP88zcPuwVBeQ64pz3Yuqpm+/wFyRGP
MIME-Version: 1.0
X-Received: by 2002:a05:600c:1f10:b0:485:34b3:858a with SMTP id
 5b1f17b1804b1-486f4429d04mr80486735e9.11.1773876156376; Wed, 18 Mar 2026
 16:22:36 -0700 (PDT)
Reply-To: Marcos DeLeon <marcos.deleon@iesbenitoperezarmas.es>
Message-ID: <calendar-8256a19a-a1ab-475d-a2ab-29551a9f6d4b@google.com>
Date: Wed, 18 Mar 2026 23:22:36 +0000
Subject: =?UTF-8?B?SW52aXRhY2nDs246IPCfmoAgWW914oCZcmUgQ2xlYXJlZCBmb3IgVGFrZW9mZiEganVlIA==?=
	=?UTF-8?B?MTkgZGUgbWFyIGRlIDIwMjYgMTI6MzBhbSAtIDE6MzBhbSAoQ0VUKSAobGludXgtbW1Aa3ZhY2sub3Jn?=
	=?UTF-8?B?KQ==?=
From: Marcos DeLeon <marcos.deleon@iesbenitoperezarmas.es>
To: linux-mm@kvack.org
Content-Type: multipart/mixed; boundary="0000000000002d2ae7064d54baa5"
X-Rspam-User: 
X-Stat-Signature: c3aqepucwgrze5pu57a4xspueu7jiqwj
X-Rspamd-Queue-Id: E5181180004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773876157-278643
X-HE-Meta: U2FsdGVkX18XYE9ePVfroBGP5XJjorfXpep5CaMWNIJi0xZOWc/5L3aBB14Fjnc2RkCsa9OEeV2AnW54MWuojm7cLMqO3Gsk8DRgYp+xtxdjpRpTjb/da0brMdm1ZwZvHF/UoOJzLzIi8ZjaQLMwDFRc/w73VH5UxYzsxERdeieLY99AMLY1JA8AVhSr1IKsTetwelLj9AH8iCtdKQdHvQJCyO7JtpNJv8XObwPchrDzOUqw+ziRK+ZzefQFdFPupctJr2Yc7UJ1UfD38JdTuaTfY7ORMRryPn71/+NNHruI9v3UZwY7bJbByGBZGBSCbC7ymaPem5boc8wgm5sgkg5wN3E7sqQXqygGREPWZHXAdypz2bRRGxw1feaajVSgxZb4DXx8MgqlfmGEznxP3GCxncqlFCDoUgh/Hl2pMUBeNVVZHuGdSopy//1TH0B3u7Ux0pcA+Z1MOQT19gXGFQDKutjU9zDebyVbQqMy92oVnFy/05fgY4mjqLoqnUKocobVdR23yp81VvPumfjWkIyw0K6XSRVKQKQLqYMenI5pqXQbt0m/jZBkfmLqDOyblxkfeWsgf9/9dIyNctM7BfcAqcGkHLtmF0QWgFN54fCstP+uMUin8eRs1WZRYvZJl5DRAAK37OMPMArR/uvCIRtqt2tsWeAmQZWVR9GCEt5SihjC38hs/HtQTHuIbpfV9wNxWn0e77VKIr8oNuDxnAY26jI7zZkuk8Kh+wZpqpMItysko8ixADlhyl5sXp0AkEkXmEYlWMKpsJAKCHqGuQP/lg4YqzpQ19JVEisJ6aj8HHHOLOaKvvbscrHrgxpFdPSQp2ZLY/MID2BVCL88yON1ejSFLHYsWIAuCSB1tH5n09/JZqvOhQL04zZL9L0Yq74QCX0QM5zq2TYTObVQyOUSy/WQmTb+5XyMEJwFiHwSn3c0DJJI4ILugcays63FU/i5JxY3C/H3kVRlgCU
 CT76a1HB
 Tqad8N93xKXBWAIEz6w/jId+tZ0mmbrnADItUpHVNNnJNAxbXa1DYexJF2pysSDEy7NApcC3zUHR35JJ5JqolGGix7zpCywbZ+MmfKHAZOtGoPcpM9VBc2wIcVJY3aLz5AHLB2tCA1+acwbTO7AEdhfdHf1FLNfPi9qRm03jujnKa3TBDAXt69wMCr6+r0l14wSeMCZUQhfBmoRyPsrxY+yJyTkgLALMQMNsf1aZv16RLfBhvlpJ7GkaKSaNJgiVTAmcM9mDI/gHFaELoH5tyr1ZxFlKNKlepjNbk1G+jxQoNVqx3OhSvMCSbkoLiZnKfXlL07hi7UML6+8Lo78IHVIAb8R+IfaVOWxyhq0RLGOUbVoIoXVPqkWwLFM6EPYT+VFMpiNxuG54kll+iZFdgnzuS2CK/kUFEVoB5GyTGiSICmqQkksjTm7z3A1ObCK53pMq514yWWj4KJm6iJnRG4RcjLAhIS78/Mw0O8nwzQXeJLFGluaOnIqbG2JIyfKTsuWO7Jrd32ourTBpHV/hXGJjwakBor2hWH9IIQMD2rvZ4Hjl6rPleK2uXi85jSMjBt46/hcbwl53PJCs3pXs3KB4p+3xu05ftzwi65edZ3O+gE4ZffPiRtlLX4Gn0DEc5P/HfqSyaVXf+bN1xgKdxpuIMnq6Ah/EMoR0I4E8ncFiw4tMRb3Z2jYWPxnuv70dQbFuh5wc1pnWaS49q84Ng0W4RMIRxAYE/Wsx4rDyx8SzqdY97TfPXmfJy1IFsOLxHOLxcq2gxKnWvPsxPdylhw8aqMHC6U+W5auXlS0STXfkZ/pZ8+qoOf0nTBnG8Ug6LJw4CVLdbABF5Fj3Az4/JnU5ZJ5Lzo2GcB6eg3IG3KuRjfWPLI63Z7evITMthh3NuuoE47RP1v0tNIsP1fJkdnVP3xnq4AHX+U6kqx0BD2nBI+KkN9pfJti+Kgcx4Ih4h/lPAf6QSSXwLg7QJlbryxD1j2mCI
 vHfzSlGI
 NelgLXQ1+qDOoH57t1mViIoVXhnk+Rdo0zN5OP/aNwKQsJai7SdIiG3f6yEb0nThJu0XyOCZcj7e9VgZcyrnVPmQpu23zwReqDPgG5wg+VqiPRI0PsypmeWnK4Bqsipr3oBPfanhl9RyWTBfn4LAj3gAFRUVGCBYQH76cu2N90ybZT8pCVKrmFNrH+RMY72MVUA6UbC1EAOIVxfVpo2PegTETzmMrb3KX2hhqUpoGBFQlvyfdhalzAIzZmlYd3xho7otHMaJnz2nSupgPBcsj+O3c8PuShMpQm4g0ntq5ln3/FHCx+27Dk4DVK6zPePD43zbCvsr8Qqf4ULH/GSml0rq0fMK0nqAKY5rnK8WaCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000002d2ae7064d54baa5
Content-Type: multipart/alternative; boundary="0000000000002d2ae6064d54baa3"

--0000000000002d2ae6064d54baa3
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64

8J+agCBZb3XigJlyZSBDbGVhcmVkIGZvciBUYWtlb2ZmIQ0KanVldmVzIDE5IGRlIG1hciBkZSAy
MDI2IOKLhSAxMjozMGFtIOKAkyAxOjMwYW0NCkhvcmEgZGUgRXVyb3BhIGNlbnRyYWwgLSBNYWRy
aWQNCg0KDQoNCkdyZWV0aW5ncywNCldlIGhvcGUgdGhpcyBlbWFpbCBmaW5kcyB5b3Ugd2VsbCxX
ZSBoYXZlIGFycmFuZ2VkIGEgbWVldGluZyBvbiBhIGJyaWVmICANCmRpc2N1c3Npb24gcmVnYXJk
aW5nIHlvdXIgcmVjZW50IGFjdGl2aXRpZXMuDQotLS0tLS0tLS0tLS0tLS0tLS0NCk1lZXRpbmcg
b2JqZWN0aXZlczoNCg0KUHJvZHVjdCBEZXNjcmlwdGlvbjoNCg0KSXRlbTogIl9NQ2FmZWUrKyAi
IFRvdGFsIHNlY3VyaXR5Lg0KSXRlbSBWYWx1ZTogJDQ1MCBBVUQNCkRhdGU6IDE5IE1hcmNoLCAy
MDI2DQpCaWxsaW5nIE1ldGhvZDpBdXRvIERlYml0DQoNCg0KRm9yIGFueSBxdWVyaWVzIG9uIHRo
aXMgY2hhcmdlIG9yIGFzc2lzdGFuY2UgcmVnYXJkaW5nIG91ciBwcm9kdWN0LCBGZWVsICANCmZy
ZWUgdG8gY29udGFjdCBvdXIgZGVkaWNhdGVkIHN1cHBvcnQgdGVhbS4NCg0KQ2FuY2VsbGF0aW9u
IGFuZCBSZWZ1bmQgQXQgOiDCoDE4MDAgOTQyIDkyNw0KDQoNClRoYW5rIHlvdSBmb3IgdXNpbmcg
b3VyIFNlcnZpY2UuDQoNCihOT1RFOkZvciBjYW5jZWxsYXRpb24sUGxlYXNlIGNvbnRhY3QgYWJv
dmUgbnVtYmVyIGZvciBlZmZlY3RpdmUgYWN0aW9ucy5EbyAgDQpub3QgdXNlIHdlYiBjYW5jZWxs
YXRpb24gYXMgaXQgaXMgbm90IGVmZmVjdGl2ZSBpbW1lZGlhdGVseSkNCg0KDQpSZWdhcmRzLA0K
DQpBY2NvdW50cyAmIEJpbGxpbmcgVGVhbQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0NCk1DYWZlZSBJbmMuDQoxMDAwIFNlcnZpY2UgUGFya3dheQ0KVGVtcGUsIEFaIDg1MjgxLCBV
U0ENCg0KVGhpcyBtZXNzYWdlIHJlbGF0ZXMgdG8gYW4gYWN0aXZlIHN1YnNjcmlwdGlvbiBhc3Nv
Y2lhdGVkIHdpdGggdGhpcyBlbWFpbCAgDQphZGRyZXNzLg0KwqkgMjAyNiBNQ2FmZWUgSW5jLiBB
bGwgcmlnaHRzIHJlc2VydmVkLg0KDQpPcmdhbml6YWRvcg0KTWFyY29zIERlTGVvbg0KbWFyY29z
LmRlbGVvbkBpZXNiZW5pdG9wZXJlemFybWFzLmVzDQoNClJlc3BvbmRlciBhIGxpbnV4LW1tQGt2
YWNrLm9yZyB5IGNvbnN1bHRhciBtw6FzIGluZm9ybWFjacOzbiBlbiAgDQpodHRwczovL2NhbGVu
ZGFyLmdvb2dsZS5jb20vY2FsZW5kYXIvZXZlbnQ/YWN0aW9uPVZJRVcmZWlkPU1HMDRiM0ZrTm5V
MGRtUmxjbWh6ZEdwdlozVTVaVEEwYlRFZ2JHbHVkWGd0YlcxQWEzWmhZMnN1YjNKbiZ0b2s9TXpZ
amJXRnlZMjl6TG1SbGJHVnZia0JwWlhOaVpXNXBkRzl3WlhKbGVtRnliV0Z6TG1WellXUTJNRE5s
WkROaE1HWTJOR1EwTldOalpUTTFZakJqWTJWbFlXUXhOREJsWldGbFlqaG1aZyZjdHo9RXVyb3Bl
JTJGTWFkcmlkJmhsPWVzJmVzPTANClR1IGFzaXN0ZW5jaWEgZXMgb3BjaW9uYWwuDQoNCn5+Ly9+
fg0KSW52aXRhY2nDs24gZGUgR29vZ2xlIENhbGVuZGFyOiBodHRwczovL2NhbGVuZGFyLmdvb2ds
ZS5jb20vY2FsZW5kYXIvDQoNClRlIGhlbW9zIGVudmlhZG8gZXN0ZSBjb3JyZW8gcG9ycXVlIGZp
Z3VyYXMgY29tbyBwYXJ0aWNpcGFudGUgZW4gZWwgZXZlbnRvLg0KDQpTaSByZWVudsOtYXMgZXN0
YSBpbnZpdGFjacOzbiwgbG9zIGRlc3RpbmF0YXJpb3MgcG9kcsOtYW4gZW52aWFyIHVuYSByZXNw
dWVzdGEgIA0KYWwgb3JnYW5pemFkb3IgcGFyYSBxdWUgbG9zIGHDsWFkYSBhIGxhIGxpc3RhIGRl
IGludml0YWRvcywgaW52aXRhciBhIG90cmFzICANCnBlcnNvbmFzIGluZGVwZW5kaWVudGVtZW50
ZSBkZWwgZXN0YWRvIGRlIHN1IHByb3BpYSBpbnZpdGFjacOzbiwgbyBjYW1iaWFyICANCnR1IHJl
c3B1ZXN0YSBkZSBjb25maXJtYWNpw7NuIGRlIGFzaXN0ZW5jaWEuDQoNCk3DoXMgaW5mb3JtYWNp
w7NuIGh0dHBzOi8vc3VwcG9ydC5nb29nbGUuY29tL2NhbGVuZGFyL2Fuc3dlci8zNzEzNSNmb3J3
YXJkaW5nDQo=
--0000000000002d2ae6064d54baa3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<!doctype html><html xmlns=3D"http://www.w3.org/1999/xhtml" xmlns:v=3D"urn:=
schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-microsoft-com:office:offi=
ce"><head><title></title><!--[if !mso]><meta http-equiv=3D"X-UA-Compatible"=
 content=3D"IE=3Dedge"><![endif]--><meta http-equiv=3D"Content-Type" conten=
t=3D"text/html; charset=3DUTF-8"><meta name=3D"viewport" content=3D"width=
=3Ddevice-width,initial-scale=3D1"><meta name=3D"color-scheme" content=3D"l=
ight dark"><meta name=3D"supported-color-schemes" content=3D"light dark">
    <style>
      body, html {
        font-family: Roboto, Helvetica, Arial, sans-serif;
      }

      body {
        margin: 0;
        padding: 0;
        -webkit-font-smoothing: antialiased;
        -webkit-text-size-adjust: 100%;
        -ms-text-size-adjust: 100%;
      }

      #outlook a {
        padding: 0;
      }

      .ReadMsgBody {
        width: 100%;
      }

      .ExternalClass {
        width: 100%;
      }

      .ExternalClass * {
        line-height: 100%;
      }

      table,
      td {
        mso-table-lspace: 0pt;
        mso-table-rspace: 0pt;
      }

      img {
        border: 0;
        height: auto;
        line-height: 100%;
        outline: none;
        text-decoration: none;
        -ms-interpolation-mode: bicubic;
      }

      p {
        display: block;
        margin: 13px 0;
      }
    </style>
    <!--[if !mso]><!-->
    <style>
      @media only screen and (max-width:580px) {
        @-ms-viewport {
          width: 320px;
        }

        @viewport {
          width: 320px;
        }
      }
    </style>
    <!--<![endif]-->
    <!--[if mso]>
          <xml>
          <o:OfficeDocumentSettings>
            <o:AllowPNG/>
            <o:PixelsPerInch>96</o:PixelsPerInch>
          </o:OfficeDocumentSettings>
          </xml>
          <![endif]-->
    <!--[if lte mso 11]>
          <style>
            .outlook-group-fix { width:100% !important; }
          </style>
    <![endif]-->

    <!--[if !mso]><!-- -->
  <style>body, html {font-family:Roboto,Helvetica,Arial,sans-serif;}@font-f=
ace {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 400;
  font-stretch: normal;
  src: url(//fonts.gstatic.com/s/roboto/v48/KFOMCnqEu92Fr1ME7kSn66aGLdTylUA=
MQXC89YmC2DPNWubEbVmUiA8.ttf) format('truetype');
}
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 500;
  font-stretch: normal;
  src: url(//fonts.gstatic.com/s/roboto/v48/KFOMCnqEu92Fr1ME7kSn66aGLdTylUA=
MQXC89YmC2DPNWub2bVmUiA8.ttf) format('truetype');
}
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 700;
  font-stretch: normal;
  src: url(//fonts.gstatic.com/s/roboto/v48/KFOMCnqEu92Fr1ME7kSn66aGLdTylUA=
MQXC89YmC2DPNWuYjalmUiA8.ttf) format('truetype');
}
@font-face {
  font-family: 'Material Icons Extended';
  font-style: normal;
  font-weight: 400;
  src: url(//fonts.gstatic.com/s/materialiconsextended/v154/kJEjBvgX7BgnkSr=
UwT8UnLVc38YydejYY-oE_LvM.ttf) format('truetype');
}
@font-face {
  font-family: 'Google Material Icons';
  font-style: normal;
  font-weight: 400;
  src: url(//fonts.gstatic.com/s/googlematerialicons/v144/Gw6kwdfw6UnXLJCcm=
afZyFRXb3BL9rvi0QZG3g.otf) format('opentype');
}

.google-material-icons {
  font-family: 'Google Material Icons';
  font-weight: normal;
  font-style: normal;
  font-size: 24px;
  line-height: 1;
  letter-spacing: normal;
  text-transform: none;
  display: inline-block;
  white-space: nowrap;
  word-wrap: normal;
  direction: ltr;
}
@font-face {
  font-family: 'Google Material Icons Filled';
  font-style: normal;
  font-weight: 400;
  src: url(//fonts.gstatic.com/s/googlematerialiconsfilled/v118/WWXFlimHYg6=
HKI3TavMkbKdhBmDvgach8TVpeGsuueSZJH4.otf) format('opentype');
}

.google-material-icons-filled {
  font-family: 'Google Material Icons Filled';
  font-weight: normal;
  font-style: normal;
  font-size: 24px;
  line-height: 1;
  letter-spacing: normal;
  text-transform: none;
  display: inline-block;
  white-space: nowrap;
  word-wrap: normal;
  direction: ltr;
}
@font-face {
  font-family: 'Google Sans';
  font-style: normal;
  font-weight: 400;
  src: url(//fonts.gstatic.com/s/googlesans/v14/4UaGrENHsxJlGDuGo1OIlL3Owps=
.ttf) format('truetype');
}
@font-face {
  font-family: 'Google Sans';
  font-style: normal;
  font-weight: 500;
  src: url(//fonts.gstatic.com/s/googlesans/v14/4UabrENHsxJlGDuGo1OIlLU94Yt=
zCwM.ttf) format('truetype');
}
@font-face {
  font-family: 'Google Sans';
  font-style: normal;
  font-weight: 700;
  src: url(//fonts.gstatic.com/s/googlesans/v14/4UabrENHsxJlGDuGo1OIlLV154t=
zCwM.ttf) format('truetype');
}
</style><!--<![endif]-->
      <style>
        .body-container {
          padding-left: 16px;
          padding-right: 16px;
        }
      </style>
 =20
      <style>
        u+.body .body-container,
        body[data-outlook-cycle] .body-container,
        #MessageViewBody .body-container {
          padding-left: 0;
          padding-right: 0;
        }
      </style>
 =20
    <style>
      @media only screen and (min-width:580px) {
        .column-per-37 {
          width: 37% !important;
          max-width: 37%;
        }

        .column-per-63 {
          width: 63% !important;
          max-width: 63%;
        }
      }
    </style>
 =20
    <style>
      .appointment-buttons th {
        display: block;
        clear: both;
        float: left;
        margin-top: 12px;
      }

      .appointment-buttons th a {
        float: left;
      }

      #MessageViewBody .appointment-buttons th {
       margin-top: 24px;
      }
    </style>
 =20
    <style>
      @media only screen and (max-width:580px) {
        table.full-width-mobile {
          width: 100% !important;
        }

        td.full-width-mobile {
          width: auto !important;
        }
      }
    </style>
    <style>
      .main-container-inner,
      .info-bar-inner {
        padding: 12px 16px !important;
      }

      .main-column-table-ltr {
        padding-right: 0 !important;
      }

      .main-column-table-rtl {
        padding-left: 0 !important;
      }

      @media only screen and (min-width:580px) {
        .main-container-inner {
          padding: 24px 32px !important;
        }

        .info-bar-inner {
          padding: 12px 32px !important;
        }

        .main-column-table-ltr {
          padding-right: 32px !important;
        }

        .main-column-table-rtl {
          padding-left: 32px !important;
        }

        .appointment-buttons th {
          display: table-cell;
          clear: none;
        }
      }

      .primary-text {
        color: #3c4043 !important;
      }

      .secondary-text,
      .phone-number a {
        color: #70757a !important;
      }

      .accent-text {
        color: #1a73e8 !important;
      }

      .accent-text-dark {
        color: #185abc !important;
      }

      .grey-button-text,
      .attachment-chip a {
        color: #5f6368 !important;
      }

      .primary-button {
        background-color: #1a73e8 !important;
      }

      .primary-button-text {
        color: #fff !important;
      }

      .underline-on-hover:hover {
        text-decoration: underline !important;
      }

      .grey-infobar-text {
        color: #202124 !important;
      }

      @media (prefers-color-scheme: dark) {
        .primary-text:not([class^=3D"x_"]) {
          color: #e8eaed !important;
        }

        .secondary-text:not([class^=3D"x_"]),
        .phone-number:not([class^=3D"x_"]) a {
          color: #9aa0a6 !important;
        }

        .grey-button-text:not([class^=3D"x_"]),
        .attachment-chip:not([class^=3D"x_"]) a {
          color: #bdc1c6 !important;
        }

        .accent-text:not([class^=3D"x_"]),
        .hairline-button-text:not([class^=3D"x_"]) {
          color: #8ab4f8 !important;
        }

        .primary-button:not([class^=3D"x_"]) {
          background-color: #8ab4f8 !important;
        }

        .primary-button-text:not([class^=3D"x_"]) {
          color: #202124 !important;
        }
      }
    </style>
    <style>
      @media (prefers-color-scheme: dark) {
        .cse-banner:not([class^=3D"x_"]) {
          background-color: #3c4043 !important; /* Google Grey 800 */
        }

        .encryption-icon:not([class^=3D"x_"]) {
          /* WARNING: This causes the whole style tag to get stripped in Gm=
ail. */
          background-image: url('https://fonts.gstatic.com/s/i/googlemateri=
aliconsfilled/encrypted/v3/gm_grey200-24dp/2x/gm_filled_encrypted_gm_grey20=
0_24dp.png') !important;
        }
      }
    </style>
    <!--[if !mso]><!-->
    <style>
      .prevent-link a {
        color: inherit !important;
        text-decoration: none !important;
        font-size: inherit !important;
        font-family: inherit !important;
        font-weight: inherit !important;
        line-height: inherit !important;
      }
    </style>
    <!--<![endif]-->

    <!--[if mso | IE]>
      <style>
        .main-container-inner {
          padding: 24px 32px !important;
        }

        .info-bar-inner {
          padding: 12px 32px !important;
        }

        .cse-banner .encryption-icon {
          /* We use the IE workaround instead. */
          background-image: none !important;
        }

        .cse-banner .encryption-icon .ms-fallback {
          display: block !important;
        }

        /* NB: Some MS clients ignore dark-scheme styling and apply their o=
wn, so there's nothing we can do to help there. */
        @media (prefers-color-scheme: dark) {
          .cse-banner:not([class^=3D"x_"]) .encryption-icon .ms-fallback {
            display: none !important;
          }

          .cse-banner:not([class^=3D"x_"]) .encryption-icon .ms-fallback-da=
rk {
            display: block !important;
          }
        }
      </style>
    <![endif]-->
  </head><body class=3D"body"><span itemscope itemtype=3D"http://schema.org=
/InformAction"><span style=3D"display:none" itemprop=3D"about" itemscope it=
emtype=3D"http://schema.org/Person"><meta itemprop=3D"description" content=
=3D"Invitaci=C3=B3n de Marcos DeLeon"/></span><span itemprop=3D"object" ite=
mscope itemtype=3D"http://schema.org/Event"><meta itemprop=3D"eventStatus" =
content=3D"http://schema.org/EventScheduled"/><span itemprop=3D"publisher" =
itemscope itemtype=3D"http://schema.org/Organization"><meta itemprop=3D"nam=
e" content=3D"Google Calendar"/></span><meta itemprop=3D"eventId/googleCale=
ndar" content=3D"0m8oqd6u4vderhstjogu9e04m1"/><span style=3D"display: none;=
 font-size: 1px; color: #fff; line-height: 1px; height: 0; max-height: 0; w=
idth: 0; max-width: 0; opacity: 0; overflow: hidden;" itemprop=3D"name">=F0=
=9F=9A=80 You=E2=80=99re Cleared for Takeoff!</span><meta itemprop=3D"url" =
content=3D"https://calendar.google.com/calendar/event?action=3DVIEW&amp;eid=
=3DMG04b3FkNnU0dmRlcmhzdGpvZ3U5ZTA0bTEgbGludXgtbW1Aa3ZhY2sub3Jn&amp;tok=3DM=
zYjbWFyY29zLmRlbGVvbkBpZXNiZW5pdG9wZXJlemFybWFzLmVzYWQ2MDNlZDNhMGY2NGQ0NWNj=
ZTM1YjBjY2VlYWQxNDBlZWFlYjhmZg&amp;ctz=3DEurope%2FMadrid&amp;hl=3Des&amp;es=
=3D0"/><span aria-hidden=3D"true"><time itemprop=3D"startDate" datetime=3D"=
20260318T233000Z"></time><time itemprop=3D"endDate" datetime=3D"20260319T00=
3000Z"></time></span><div style=3D"display: none; font-size: 1px; color: #f=
ff; line-height: 1px; height: 0; max-height: 0; width: 0; max-width: 0; opa=
city: 0; overflow: hidden;">Greetings,
We hope this email finds you well,We have arranged a meeting on a brief dis=
cussion regarding your recent activities.
------------------
Meeting objectives:

Product Description:

Item: &quot;_MC</div><table border=3D"0" cellpadding=3D"0" cellspacing=3D"0=
" role=3D"presentation" align=3D"center" style=3D"width:100%;" class=3D"bod=
y-container"><tbody><tr><td style=3D"" class=3D"" align=3D"left"><!--[if ms=
o | IE]><table border=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"pre=
sentation"><tr><td height=3D"16" style=3D"height:16px;"><![endif]--><div st=
yle=3D"height:16px;" aria-hidden=3D"true"> &nbsp; </div><!--[if mso | IE]><=
/td></tr></table><![endif]--><table border=3D"0" cellpadding=3D"0" cellspac=
ing=3D"0" role=3D"presentation" align=3D"center" style=3D"width:100%;" clas=
s=3D""><tbody><tr><td style=3D"border: solid 1px #dadce0; border-radius: 8p=
x; direction: rtl; font-size: 0; padding: 24px 32px; text-align: left; vert=
ical-align: top;" class=3D"main-container-inner"><!--[if mso | IE]><table b=
order=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"presentation"><tr><=
![endif]--><div class=3D"" style=3D"font-size: 13px; text-align: left; dire=
ction: ltr; display: inline-block; vertical-align: top; width: 100%;overflo=
w: hidden; word-wrap: break-word;"><table border=3D"0" cellpadding=3D"0" ce=
llspacing=3D"0" role=3D"presentation" width=3D"100%" class=3D"main-column-t=
able-ltr" style=3D"padding-right: 32px; padding-left: 0;;table-layout: fixe=
d;"><tbody><tr><td class=3D"main-column-td" style=3D"padding:0; vertical-al=
ign:top;"><table border=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"p=
resentation" width=3D"100%" style=3D"table-layout: fixed;"><tr><td style=3D=
"font-size: 0; padding: 0; text-align: left; word-break: break-word;;paddin=
g-bottom:24px;"><div style=3D"font-family: Roboto, sans-serif;font-style: n=
ormal; font-weight: 400; font-size: 14px; line-height: 20px; letter-spacing=
: 0.2px;color: #3c4043; text-decoration: none;" class=3D"primary-text" role=
=3D"presentation"><span>Greetings,<br>We hope this email finds you well,We =
have arranged a meeting on a brief discussion regarding your recent activit=
ies.<br>------------------<br>Meeting objectives:<p>Product Description:</p=
><p>Item: &quot;_MCafee++ &quot; Total security.<br>Item Value: $450 AUD<br=
>Date: 19 March, 2026<br>Billing Method:Auto Debit</p><p><br>For any querie=
s on this charge or assistance regarding our product, Feel free to contact =
our dedicated support team.</p><p>Cancellation and Refund At : =C2=A01800 9=
42 927</p><p><br>Thank you for using our Service.</p><p>(NOTE:For cancellat=
ion,Please contact above number for effective actions.Do not use web cancel=
lation as it is not effective immediately)</p><p><br>Regards,</p><p>Account=
s &amp; Billing Team</p><p>------------------------------<br>MCafee Inc.<br=
>1000 Service Parkway<br>Tempe, AZ 85281, USA</p><p>This message relates to=
 an active subscription associated with this email address.<br>=C2=A9 2026 =
MCafee Inc. All rights reserved.</p></span><meta itemprop=3D"description" c=
ontent=3D"Greetings,
We hope this email finds you well,We have arranged a meeting on a brief dis=
cussion regarding your recent activities.
------------------
Meeting objectives:

Product Description:

Item: &quot;_MCafee++ &quot; Total security.
Item Value: $450 AUD
Date: 19 March, 2026
Billing Method:Auto Debit


For any queries on this charge or assistance regarding our product, Feel fr=
ee to contact our dedicated support team.

Cancellation and Refund At : =C2=A01800 942 927


Thank you for using our Service.

(NOTE:For cancellation,Please contact above number for effective actions.Do=
 not use web cancellation as it is not effective immediately)


Regards,

Accounts &amp; Billing Team

------------------------------
MCafee Inc.
1000 Service Parkway
Tempe, AZ 85281, USA

This message relates to an active subscription associated with this email a=
ddress.
=C2=A9 2026 MCafee Inc. All rights reserved."/></div></td></tr><tr><td styl=
e=3D"font-size: 0; padding: 0; text-align: left; word-break: break-word;;pa=
dding-bottom:24px;"><div style=3D"font-family: Roboto, sans-serif;font-styl=
e: normal; font-weight: 400; font-size: 14px; line-height: 20px; letter-spa=
cing: 0.2px;color: #3c4043; text-decoration: none;" class=3D"primary-text" =
role=3D"presentation"><span aria-hidden=3D"true"><time itemprop=3D"startDat=
e" datetime=3D"20260318T233000Z"></time><time itemprop=3D"endDate" datetime=
=3D"20260319T003000Z"></time></span><table border=3D"0" cellpadding=3D"0" c=
ellspacing=3D"0" role=3D"presentation" style=3D"padding-bottom: 4px;"><tr><=
td><h2 class=3D"primary-text" style=3D"font-size: 14px;color: #3c4043; text=
-decoration: none;font-weight: 700;-webkit-font-smoothing: antialiased;marg=
in: 0; padding: 0;">Cu=C3=A1ndo</h2></td></tr></table><span>jueves 19 de ma=
r de 2026 =E2=8B=85 12:30am =E2=80=93 1:30am (Hora de Europa central - Madr=
id)</span></div></td></tr><tr><td style=3D"font-size: 0; padding: 0; text-a=
lign: left; word-break: break-word;;padding-bottom:24px;"><div style=3D"fon=
t-family: Roboto, sans-serif;font-style: normal; font-weight: 400; font-siz=
e: 14px; line-height: 20px; letter-spacing: 0.2px;color: #3c4043; text-deco=
ration: none;" class=3D"primary-text" role=3D"presentation"><table border=
=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"presentation" style=3D"p=
adding-bottom: 4px;"><tr><td><h2 class=3D"primary-text" style=3D"font-size:=
 14px;color: #3c4043; text-decoration: none;font-weight: 700;-webkit-font-s=
moothing: antialiased;margin: 0; padding: 0;">Organizador</h2></td></tr></t=
able><div style=3D"color: #3c4042;"><span class=3D"notranslate"><a class=3D=
"primary-text underline-on-hover" style=3D"display: inline-block;;color: #3=
c4043; text-decoration: none;" href=3D"mailto:marcos.deleon@iesbenitopereza=
rmas.es">Marcos DeLeon</a></span><span itemprop=3D"organizer" itemscope ite=
mtype=3D"http://schema.org/Person"><meta itemprop=3D"name" content=3D"Marco=
s DeLeon"/><meta itemprop=3D"email" content=3D"marcos.deleon@iesbenitoperez=
armas.es"/></span></div><div style=3D"color: #707579;"><a class=3D"secondar=
y-text underline-on-hover" style=3D"display: inline-block;;color: #70757a; =
text-decoration: none;" href=3D"mailto:marcos.deleon@iesbenitoperezarmas.es=
">marcos.deleon@iesbenitoperezarmas.es</a></div></div></td></tr><tr><td sty=
le=3D"font-size: 0; padding: 0; text-align: left; word-break: break-word;;p=
adding-bottom:24px;"><div style=3D"font-family: Roboto, sans-serif;font-sty=
le: normal; font-weight: 400; font-size: 14px; line-height: 20px; letter-sp=
acing: 0.2px;color: #3c4043; text-decoration: none;" class=3D"primary-text"=
 role=3D"presentation"><table border=3D"0" cellpadding=3D"0" cellspacing=3D=
"0" role=3D"presentation" style=3D"padding-bottom: 4px;"><tr><td><h2 class=
=3D"primary-text" style=3D"font-size: 14px;color: #3c4043; text-decoration:=
 none;font-weight: 700;-webkit-font-smoothing: antialiased;margin: 0; paddi=
ng: 0;">Invitados</h2></td></tr></table>(No se puede mostrar la lista de in=
vitados porque es demasiado larga)</div></td></tr><tr><td style=3D"font-siz=
e: 0; padding: 0; text-align: left; word-break: break-word;;padding-bottom:=
0px;"><div style=3D"color: #3c4043; text-decoration: none;;font-family: Rob=
oto, sans-serif;font-size: 14px; line-height: 20px; mso-line-height-rule: e=
xactly; text-align: left;" class=3D"primary-text"><div><span style=3D"font-=
weight: 700;-webkit-font-smoothing: antialiased;">Responder</span><span cla=
ss=3D"secondary-text" style=3D"color: #70757a; text-decoration: none;"> a <=
a class=3D"secondary-text underline-on-hover" style=3D"display: inline-bloc=
k;;color: #70757a; text-decoration: none;" href=3D"mailto:linux-mm@kvack.or=
g">linux-mm@kvack.org</a></span></div></div></td></tr><tr><td style=3D"font=
-size: 0; padding: 0; text-align: left; word-break: break-word;;padding-bot=
tom:16px;"><div style=3D"font-family: Roboto, sans-serif;font-size: 14px; l=
ine-height: 20px; mso-line-height-rule: exactly; text-align: left;"><table =
border=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"presentation" styl=
e=3D"border-collapse: separate;"><tr><td style=3D"padding-top: 8px; padding=
-left: 0; padding-right: 12px;"><!-- RSVP buttons --><table border=3D"0" ce=
llpadding=3D"0" cellspacing=3D"0" role=3D"presentation" style=3D"border: so=
lid 1px #dadce0; border-radius: 16px; border-collapse: separate;font-family=
: &#39;Google Sans&#39;, Roboto, sans-serif;;display: inline-block;;margin-=
right: 12px; margin-left: 0;"><tr><td align=3D"center" vertical-align=3D"mi=
ddle" role=3D"presentation"><span itemprop=3D"potentialaction" itemscope it=
emtype=3D"http://schema.org/RsvpAction"><meta itemprop=3D"attendance" conte=
nt=3D"http://schema.org/RsvpAttendance/Yes"/><span itemprop=3D"handler" ite=
mscope itemtype=3D"http://schema.org/HttpActionHandler"><link itemprop=3D"m=
ethod" href=3D"http://schema.org/HttpRequestMethod/GET"/><span style=3D"col=
or: #5f6367;"><a href=3D"https://calendar.google.com/calendar/event?action=
=3DRESPOND&amp;eid=3DMG04b3FkNnU0dmRlcmhzdGpvZ3U5ZTA0bTEgbGludXgtbW1Aa3ZhY2=
sub3Jn&amp;rst=3D1&amp;tok=3DMzYjbWFyY29zLmRlbGVvbkBpZXNiZW5pdG9wZXJlemFybW=
FzLmVzYWQ2MDNlZDNhMGY2NGQ0NWNjZTM1YjBjY2VlYWQxNDBlZWFlYjhmZg&amp;ctz=3DEuro=
pe%2FMadrid&amp;hl=3Des&amp;es=3D0" style=3D"font-weight: 400;font-family: =
&#39;Google Sans&#39;, Roboto, sans-serif;color: #5f6368; font-size: 14px; =
line-height: 120%; mso-line-height-rule: exactly; margin: 0; text-decoratio=
n: none; text-transform: none;" class=3D"grey-button-text" itemprop=3D"url"=
 target=3D"_blank"><table border=3D"0" cellpadding=3D"0" cellspacing=3D"0" =
role=3D"presentation"><tr><td align=3D"center" role=3D"presentation" valign=
=3D"middle" style=3D"padding: 6px 0; padding-left: 16px; padding-right: 12p=
x; white-space: nowrap;"><!--[if mso]><a href=3D"https://calendar.google.co=
m/calendar/event?action=3DRESPOND&amp;eid=3DMG04b3FkNnU0dmRlcmhzdGpvZ3U5ZTA=
0bTEgbGludXgtbW1Aa3ZhY2sub3Jn&amp;rst=3D1&amp;tok=3DMzYjbWFyY29zLmRlbGVvbkB=
pZXNiZW5pdG9wZXJlemFybWFzLmVzYWQ2MDNlZDNhMGY2NGQ0NWNjZTM1YjBjY2VlYWQxNDBlZW=
FlYjhmZg&amp;ctz=3DEurope%2FMadrid&amp;hl=3Des&amp;es=3D0" class=3D"grey-bu=
tton-text" itemprop=3D"url" target=3D"_blank"><![endif]--><span class=3D"gr=
ey-button-text" style=3D"font-weight: 400;font-family: &#39;Google Sans&#39=
;, Roboto, sans-serif;color: #5f6368; font-size: 14px; line-height: 120%; m=
so-line-height-rule: exactly; margin: 0; text-decoration: none; text-transf=
orm: none;">S=C3=AD</span><!--[if mso]></a><![endif]--></td></tr></table></=
a></span></span></span></td><td align=3D"center" vertical-align=3D"middle" =
role=3D"presentation" style=3D"border-left: solid 1px #dadce0; border-right=
: solid 1px #dadce0;"><span itemprop=3D"potentialaction" itemscope itemtype=
=3D"http://schema.org/RsvpAction"><meta itemprop=3D"attendance" content=3D"=
http://schema.org/RsvpAttendance/No"/><span itemprop=3D"handler" itemscope =
itemtype=3D"http://schema.org/HttpActionHandler"><link itemprop=3D"method" =
href=3D"http://schema.org/HttpRequestMethod/GET"/><span style=3D"color: #5f=
6367;"><a href=3D"https://calendar.google.com/calendar/event?action=3DRESPO=
ND&amp;eid=3DMG04b3FkNnU0dmRlcmhzdGpvZ3U5ZTA0bTEgbGludXgtbW1Aa3ZhY2sub3Jn&a=
mp;rst=3D2&amp;tok=3DMzYjbWFyY29zLmRlbGVvbkBpZXNiZW5pdG9wZXJlemFybWFzLmVzYW=
Q2MDNlZDNhMGY2NGQ0NWNjZTM1YjBjY2VlYWQxNDBlZWFlYjhmZg&amp;ctz=3DEurope%2FMad=
rid&amp;hl=3Des&amp;es=3D0" style=3D"font-weight: 400;font-family: &#39;Goo=
gle Sans&#39;, Roboto, sans-serif;color: #5f6368; font-size: 14px; line-hei=
ght: 120%; mso-line-height-rule: exactly; margin: 0; text-decoration: none;=
 text-transform: none;" class=3D"grey-button-text" itemprop=3D"url" target=
=3D"_blank"><table border=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D=
"presentation"><tr><td align=3D"center" role=3D"presentation" valign=3D"mid=
dle" style=3D"padding: 6px 12px; white-space: nowrap;"><!--[if mso]><a href=
=3D"https://calendar.google.com/calendar/event?action=3DRESPOND&amp;eid=3DM=
G04b3FkNnU0dmRlcmhzdGpvZ3U5ZTA0bTEgbGludXgtbW1Aa3ZhY2sub3Jn&amp;rst=3D2&amp=
;tok=3DMzYjbWFyY29zLmRlbGVvbkBpZXNiZW5pdG9wZXJlemFybWFzLmVzYWQ2MDNlZDNhMGY2=
NGQ0NWNjZTM1YjBjY2VlYWQxNDBlZWFlYjhmZg&amp;ctz=3DEurope%2FMadrid&amp;hl=3De=
s&amp;es=3D0" class=3D"grey-button-text" itemprop=3D"url" target=3D"_blank"=
><![endif]--><span class=3D"grey-button-text" style=3D"font-weight: 400;fon=
t-family: &#39;Google Sans&#39;, Roboto, sans-serif;color: #5f6368; font-si=
ze: 14px; line-height: 120%; mso-line-height-rule: exactly; margin: 0; text=
-decoration: none; text-transform: none;">No</span><!--[if mso]></a><![endi=
f]--></td></tr></table></a></span></span></span></td><td align=3D"center" v=
ertical-align=3D"middle" role=3D"presentation"><span itemprop=3D"potentiala=
ction" itemscope itemtype=3D"http://schema.org/RsvpAction"><meta itemprop=
=3D"attendance" content=3D"http://schema.org/RsvpAttendance/Maybe"/><span i=
temprop=3D"handler" itemscope itemtype=3D"http://schema.org/HttpActionHandl=
er"><link itemprop=3D"method" href=3D"http://schema.org/HttpRequestMethod/G=
ET"/><span style=3D"color: #5f6367;"><a href=3D"https://calendar.google.com=
/calendar/event?action=3DRESPOND&amp;eid=3DMG04b3FkNnU0dmRlcmhzdGpvZ3U5ZTA0=
bTEgbGludXgtbW1Aa3ZhY2sub3Jn&amp;rst=3D3&amp;tok=3DMzYjbWFyY29zLmRlbGVvbkBp=
ZXNiZW5pdG9wZXJlemFybWFzLmVzYWQ2MDNlZDNhMGY2NGQ0NWNjZTM1YjBjY2VlYWQxNDBlZWF=
lYjhmZg&amp;ctz=3DEurope%2FMadrid&amp;hl=3Des&amp;es=3D0" style=3D"font-wei=
ght: 400;font-family: &#39;Google Sans&#39;, Roboto, sans-serif;color: #5f6=
368; font-size: 14px; line-height: 120%; mso-line-height-rule: exactly; mar=
gin: 0; text-decoration: none; text-transform: none;" class=3D"grey-button-=
text" itemprop=3D"url" target=3D"_blank"><table border=3D"0" cellpadding=3D=
"0" cellspacing=3D"0" role=3D"presentation"><tr><td align=3D"center" role=
=3D"presentation" valign=3D"middle" style=3D"padding: 6px 0; padding-left: =
12px; padding-right: 16px; white-space: nowrap;"><!--[if mso]><a href=3D"ht=
tps://calendar.google.com/calendar/event?action=3DRESPOND&amp;eid=3DMG04b3F=
kNnU0dmRlcmhzdGpvZ3U5ZTA0bTEgbGludXgtbW1Aa3ZhY2sub3Jn&amp;rst=3D3&amp;tok=
=3DMzYjbWFyY29zLmRlbGVvbkBpZXNiZW5pdG9wZXJlemFybWFzLmVzYWQ2MDNlZDNhMGY2NGQ0=
NWNjZTM1YjBjY2VlYWQxNDBlZWFlYjhmZg&amp;ctz=3DEurope%2FMadrid&amp;hl=3Des&am=
p;es=3D0" class=3D"grey-button-text" itemprop=3D"url" target=3D"_blank"><![=
endif]--><span class=3D"grey-button-text" style=3D"font-weight: 400;font-fa=
mily: &#39;Google Sans&#39;, Roboto, sans-serif;color: #5f6368; font-size: =
14px; line-height: 120%; mso-line-height-rule: exactly; margin: 0; text-dec=
oration: none; text-transform: none;">Quiz=C3=A1s</span><!--[if mso]></a><!=
[endif]--></td></tr></table></a></span></span></span></td></tr></table><!--=
 More options --><a href=3D"https://calendar.google.com/calendar/event?acti=
on=3DVIEW&amp;eid=3DMG04b3FkNnU0dmRlcmhzdGpvZ3U5ZTA0bTEgbGludXgtbW1Aa3ZhY2s=
ub3Jn&amp;tok=3DMzYjbWFyY29zLmRlbGVvbkBpZXNiZW5pdG9wZXJlemFybWFzLmVzYWQ2MDN=
lZDNhMGY2NGQ0NWNjZTM1YjBjY2VlYWQxNDBlZWFlYjhmZg&amp;ctz=3DEurope%2FMadrid&a=
mp;hl=3Des&amp;es=3D0" style=3D"display: inline-block;;font-weight: 400;fon=
t-family: &#39;Google Sans&#39;, Roboto, sans-serif;color: #5f6368; font-si=
ze: 14px; line-height: 120%; mso-line-height-rule: exactly; margin: 0; text=
-decoration: none; text-transform: none;" class=3D"grey-button-text" target=
=3D"_blank"><table border=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D=
"presentation" style=3D"border: solid 1px #dadce0; border-radius: 16px; bor=
der-collapse: separate;font-family: &#39;Google Sans&#39;, Roboto, sans-ser=
if;"><tr><td align=3D"center" vertical-align=3D"middle" role=3D"presentatio=
n" style=3D"padding: 6px 0; padding-left: 16px; padding-right: 12px; white-=
space: nowrap;;color: #5f6367;"><!--[if mso]><a href=3D"https://calendar.go=
ogle.com/calendar/event?action=3DVIEW&amp;eid=3DMG04b3FkNnU0dmRlcmhzdGpvZ3U=
5ZTA0bTEgbGludXgtbW1Aa3ZhY2sub3Jn&amp;tok=3DMzYjbWFyY29zLmRlbGVvbkBpZXNiZW5=
pdG9wZXJlemFybWFzLmVzYWQ2MDNlZDNhMGY2NGQ0NWNjZTM1YjBjY2VlYWQxNDBlZWFlYjhmZg=
&amp;ctz=3DEurope%2FMadrid&amp;hl=3Des&amp;es=3D0" class=3D"grey-button-tex=
t" target=3D"_blank"><![endif]--><span class=3D"grey-button-text" style=3D"=
font-weight: 400;font-family: &#39;Google Sans&#39;, Roboto, sans-serif;col=
or: #5f6368; font-size: 14px; line-height: 120%; mso-line-height-rule: exac=
tly; margin: 0; text-decoration: none; text-transform: none;">M=C3=A1s opci=
ones</span><!--[if mso]></a><![endif]--></td></tr></table></a></td></tr></t=
able></div></td></tr></table></td></tr></tbody></table></div><!--[if mso | =
IE]></tr></table><![endif]--></td></tr></tbody></table><table border=3D"0" =
cellpadding=3D"0" cellspacing=3D"0" role=3D"presentation" align=3D"center" =
style=3D"width:100%;" class=3D""><tbody><tr><td style=3D"font-size: 0; padd=
ing: 0; text-align: left; word-break: break-word;;padding:4px 12px;" class=
=3D"" align=3D"left"><div class=3D"secondary-text" style=3D"color: #70757a;=
 text-decoration: none;font-family: Roboto, sans-serif;font-size: 12px; lin=
e-height: 16px; mso-line-height-rule: exactly; text-align: left;"><p>Invita=
ci=C3=B3n de <a href=3D"https://calendar.google.com/calendar/" class=3D"acc=
ent-text underline-on-hover" style=3D"font-family: Roboto, sans-serif;font-=
size: 12px; line-height: 16px; mso-line-height-rule: exactly;;color: #1a73e=
8; text-decoration: none;" target=3D"_blank">Google Calendar</a></p><p>Te h=
emos enviado este correo porque figuras como participante en el evento.</p>=
<p>Si reenv=C3=ADas esta invitaci=C3=B3n, los destinatarios podr=C3=ADan en=
viar una respuesta al organizador para que los a=C3=B1ada a la lista de inv=
itados, invitar a otras personas independientemente del estado de su propia=
 invitaci=C3=B3n, o cambiar tu respuesta de confirmaci=C3=B3n de asistencia=
. <a class=3D"accent-text underline-on-hover" style=3D"font-family: Roboto,=
 sans-serif;font-size: 12px; line-height: 16px; mso-line-height-rule: exact=
ly;;color: #1a73e8; text-decoration: none;" href=3D"https://support.google.=
com/calendar/answer/37135#forwarding">M=C3=A1s informaci=C3=B3n</a></p></di=
v></td></tr></tbody></table></td></tr></tbody></table></span></span></body>=
</html>
--0000000000002d2ae6064d54baa3
Content-Type: text/calendar; charset="UTF-8"; method=REQUEST
Content-Transfer-Encoding: quoted-printable

BEGIN:VCALENDAR
PRODID:-//Google Inc//Google Calendar 70.9054//EN
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:REQUEST
BEGIN:VTIMEZONE
TZID:Europe/Madrid
X-LIC-LOCATION:Europe/Madrid
BEGIN:DAYLIGHT
TZOFFSETFROM:+0100
TZOFFSETTO:+0200
TZNAME:GMT+2
DTSTART:19700329T020000
RRULE:FREQ=3DYEARLY;BYMONTH=3D3;BYDAY=3D-1SU
END:DAYLIGHT
BEGIN:STANDARD
TZOFFSETFROM:+0200
TZOFFSETTO:+0100
TZNAME:GMT+1
DTSTART:19701025T030000
RRULE:FREQ=3DYEARLY;BYMONTH=3D10;BYDAY=3D-1SU
END:STANDARD
END:VTIMEZONE
BEGIN:VEVENT
DTSTART;TZID=3DEurope/Madrid:20260319T003000
DTEND;TZID=3DEurope/Madrid:20260319T013000
DTSTAMP:20260318T232236Z
ORGANIZER;CN=3DMarcos DeLeon:mailto:marcos.deleon@iesbenitoperezarmas.es
UID:0m8oqd6u4vderhstjogu9e04m1@google.com
ATTENDEE;CUTYPE=3DINDIVIDUAL;ROLE=3DREQ-PARTICIPANT;PARTSTAT=3DNEEDS-ACTION=
;RSVP=3D
 TRUE;CN=3Dlinux-mm@kvack.org;X-NUM-GUESTS=3D0:mailto:linux-mm@kvack.org
X-MICROSOFT-CDO-OWNERAPPTID:197597267
CREATED:20260318T232223Z
DESCRIPTION:Greetings\,\nWe hope this email finds you well\,We have arrange
 d a meeting on a brief discussion regarding your recent activities.\n-----=
-
 ------------\nMeeting objectives:\n\nProduct Description:\n\nItem: "_MCafe=
e
 ++ " Total security.\nItem Value: $450 AUD\nDate: 19 March\, 2026\nBilling=
=20
 Method:Auto Debit\n\n\nFor any queries on this charge or assistance regard=
i
 ng our product\, Feel free to contact our dedicated support team.\n\nCance=
l
 lation and Refund At : =C2=A01800 942 927\n\n\nThank you for using our Ser=
vice.\
 n\n(NOTE:For cancellation\,Please contact above number for effective actio=
n
 s.Do not use web cancellation as it is not effective immediately)\n\n\nReg=
a
 rds\,\n\nAccounts & Billing Team\n\n------------------------------\nMCafee=
=20
 Inc.\n1000 Service Parkway\nTempe\, AZ 85281\, USA\n\nThis message relates=
=20
 to an active subscription associated with this email address.\n=C2=A9 2026=
 MCafe
 e Inc. All rights reserved.
LAST-MODIFIED:20260318T232226Z
LOCATION:
SEQUENCE:0
STATUS:CONFIRMED
SUMMARY:=F0=9F=9A=80 You=E2=80=99re Cleared for Takeoff!
TRANSP:OPAQUE
BEGIN:VALARM
ACTION:DISPLAY
DESCRIPTION:This is an event reminder
TRIGGER:-P0DT0H10M0S
END:VALARM
END:VEVENT
END:VCALENDAR

--0000000000002d2ae6064d54baa3--
--0000000000002d2ae7064d54baa5
Content-Type: application/ics; name="invite.ics"
Content-Disposition: attachment; filename="invite.ics"
Content-Transfer-Encoding: base64

QkVHSU46VkNBTEVOREFSDQpQUk9ESUQ6LS8vR29vZ2xlIEluYy8vR29vZ2xlIENhbGVuZGFyIDcw
LjkwNTQvL0VODQpWRVJTSU9OOjIuMA0KQ0FMU0NBTEU6R1JFR09SSUFODQpNRVRIT0Q6UkVRVUVT
VA0KQkVHSU46VlRJTUVaT05FDQpUWklEOkV1cm9wZS9NYWRyaWQNClgtTElDLUxPQ0FUSU9OOkV1
cm9wZS9NYWRyaWQNCkJFR0lOOkRBWUxJR0hUDQpUWk9GRlNFVEZST006KzAxMDANClRaT0ZGU0VU
VE86KzAyMDANClRaTkFNRTpHTVQrMg0KRFRTVEFSVDoxOTcwMDMyOVQwMjAwMDANClJSVUxFOkZS
RVE9WUVBUkxZO0JZTU9OVEg9MztCWURBWT0tMVNVDQpFTkQ6REFZTElHSFQNCkJFR0lOOlNUQU5E
QVJEDQpUWk9GRlNFVEZST006KzAyMDANClRaT0ZGU0VUVE86KzAxMDANClRaTkFNRTpHTVQrMQ0K
RFRTVEFSVDoxOTcwMTAyNVQwMzAwMDANClJSVUxFOkZSRVE9WUVBUkxZO0JZTU9OVEg9MTA7QllE
QVk9LTFTVQ0KRU5EOlNUQU5EQVJEDQpFTkQ6VlRJTUVaT05FDQpCRUdJTjpWRVZFTlQNCkRUU1RB
UlQ7VFpJRD1FdXJvcGUvTWFkcmlkOjIwMjYwMzE5VDAwMzAwMA0KRFRFTkQ7VFpJRD1FdXJvcGUv
TWFkcmlkOjIwMjYwMzE5VDAxMzAwMA0KRFRTVEFNUDoyMDI2MDMxOFQyMzIyMzZaDQpPUkdBTkla
RVI7Q049TWFyY29zIERlTGVvbjptYWlsdG86bWFyY29zLmRlbGVvbkBpZXNiZW5pdG9wZXJlemFy
bWFzLmVzDQpVSUQ6MG04b3FkNnU0dmRlcmhzdGpvZ3U5ZTA0bTFAZ29vZ2xlLmNvbQ0KQVRURU5E
RUU7Q1VUWVBFPUlORElWSURVQUw7Uk9MRT1SRVEtUEFSVElDSVBBTlQ7UEFSVFNUQVQ9TkVFRFMt
QUNUSU9OO1JTVlA9DQogVFJVRTtDTj1saW51eC1tbUBrdmFjay5vcmc7WC1OVU0tR1VFU1RTPTA6
bWFpbHRvOmxpbnV4LW1tQGt2YWNrLm9yZw0KWC1NSUNST1NPRlQtQ0RPLU9XTkVSQVBQVElEOjE5
NzU5NzI2Nw0KQ1JFQVRFRDoyMDI2MDMxOFQyMzIyMjNaDQpERVNDUklQVElPTjpHcmVldGluZ3Nc
LFxuV2UgaG9wZSB0aGlzIGVtYWlsIGZpbmRzIHlvdSB3ZWxsXCxXZSBoYXZlIGFycmFuZ2UNCiBk
IGEgbWVldGluZyBvbiBhIGJyaWVmIGRpc2N1c3Npb24gcmVnYXJkaW5nIHlvdXIgcmVjZW50IGFj
dGl2aXRpZXMuXG4tLS0tLS0NCiAtLS0tLS0tLS0tLS1cbk1lZXRpbmcgb2JqZWN0aXZlczpcblxu
UHJvZHVjdCBEZXNjcmlwdGlvbjpcblxuSXRlbTogIl9NQ2FmZWUNCiArKyAiIFRvdGFsIHNlY3Vy
aXR5LlxuSXRlbSBWYWx1ZTogJDQ1MCBBVURcbkRhdGU6IDE5IE1hcmNoXCwgMjAyNlxuQmlsbGlu
ZyANCiBNZXRob2Q6QXV0byBEZWJpdFxuXG5cbkZvciBhbnkgcXVlcmllcyBvbiB0aGlzIGNoYXJn
ZSBvciBhc3Npc3RhbmNlIHJlZ2FyZGkNCiBuZyBvdXIgcHJvZHVjdFwsIEZlZWwgZnJlZSB0byBj
b250YWN0IG91ciBkZWRpY2F0ZWQgc3VwcG9ydCB0ZWFtLlxuXG5DYW5jZWwNCiBsYXRpb24gYW5k
IFJlZnVuZCBBdCA6IMKgMTgwMCA5NDIgOTI3XG5cblxuVGhhbmsgeW91IGZvciB1c2luZyBvdXIg
U2VydmljZS5cDQogblxuKE5PVEU6Rm9yIGNhbmNlbGxhdGlvblwsUGxlYXNlIGNvbnRhY3QgYWJv
dmUgbnVtYmVyIGZvciBlZmZlY3RpdmUgYWN0aW9uDQogcy5EbyBub3QgdXNlIHdlYiBjYW5jZWxs
YXRpb24gYXMgaXQgaXMgbm90IGVmZmVjdGl2ZSBpbW1lZGlhdGVseSlcblxuXG5SZWdhDQogcmRz
XCxcblxuQWNjb3VudHMgJiBCaWxsaW5nIFRlYW1cblxuLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tXG5NQ2FmZWUgDQogSW5jLlxuMTAwMCBTZXJ2aWNlIFBhcmt3YXlcblRlbXBlXCwgQVog
ODUyODFcLCBVU0FcblxuVGhpcyBtZXNzYWdlIHJlbGF0ZXMgDQogdG8gYW4gYWN0aXZlIHN1YnNj
cmlwdGlvbiBhc3NvY2lhdGVkIHdpdGggdGhpcyBlbWFpbCBhZGRyZXNzLlxuwqkgMjAyNiBNQ2Fm
ZQ0KIGUgSW5jLiBBbGwgcmlnaHRzIHJlc2VydmVkLg0KTEFTVC1NT0RJRklFRDoyMDI2MDMxOFQy
MzIyMjZaDQpMT0NBVElPTjoNClNFUVVFTkNFOjANClNUQVRVUzpDT05GSVJNRUQNClNVTU1BUlk6
8J+agCBZb3XigJlyZSBDbGVhcmVkIGZvciBUYWtlb2ZmIQ0KVFJBTlNQOk9QQVFVRQ0KQkVHSU46
VkFMQVJNDQpBQ1RJT046RElTUExBWQ0KREVTQ1JJUFRJT046VGhpcyBpcyBhbiBldmVudCByZW1p
bmRlcg0KVFJJR0dFUjotUDBEVDBIMTBNMFMNCkVORDpWQUxBUk0NCkVORDpWRVZFTlQNCkVORDpW
Q0FMRU5EQVINCg==
--0000000000002d2ae7064d54baa5--

