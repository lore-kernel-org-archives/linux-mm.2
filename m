Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E35F10F3DCF
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 05:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937BC6B0095; Sat, 28 Mar 2026 01:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7F96B0096; Sat, 28 Mar 2026 01:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AF8D6B0098; Sat, 28 Mar 2026 01:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 665F76B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 01:16:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 085C7E1DF2
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 05:16:54 +0000 (UTC)
X-FDA: 84594312348.19.6DD6021
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id A822E40002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 05:16:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Gf7HM3/I";
	spf=pass (imf17.hostedemail.com: domain of tahernady45@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=tahernady45@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774675011;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3ZauplVVqH0KCCwaXuS7roK1JzTO7jEMocOaMoVsGI=;
	b=eXljfxNPHcp2pz2zpIUhsyATj76DHRI5ykpfwG9a6/zxfTCc9yF0poSZ2WwziqhJhdCxeh
	hZMpc38LUSIreEIxawdGnfHiO+IBgSMs/fMpLWpVoQ5hZPa0lOQGAx1rvC27OONJBN0wub
	20IQsJ0ApEz1GQ8TxkehZhmKXzUt9H0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Gf7HM3/I";
	spf=pass (imf17.hostedemail.com: domain of tahernady45@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=tahernady45@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774675011; a=rsa-sha256;
	cv=pass;
	b=edJlp2HRQhDKjoKbZWDQeSR9t0i63QdM0u07IaEshbnJpmGqNTv9+WdvdlJyDJNe1Tcx5e
	wRshLNgngj1BYuZVucJGA3V9U/DGlj98cJraUwr3GdxbN7EBMtw51hVNVYm436XoIO71jM
	FR1aMJGQgokUn2TH4Pgt7dGYykNQ1+s=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439b7c2788dso1657999f8f.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:16:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774675010; cv=none;
        d=google.com; s=arc-20240605;
        b=WWuTYfwoxT/5UtpYOzVZ99c/IARm26XC8S8cRBU2HJQ5o/Vsd1yKJrKnTlqgulgYjp
         aoEpCv35rNbLUGpx2/RnMdKmEij3RLfXBIrSuvki3UD0p2aKaE2DEXsvpkGSNgvOnAD0
         j6tVgP+FDXuW5mHlQ8OwrQb4/XsDZgbmgcNDF5XH9h7H/tSyNtqL6nCztCEMN0ZMjzLz
         ruupgmD4YWFaUOKPmcrpBL3Q0CKfB8dCx+OXOhlTjstdTOfsaCL1D14ubxbbZPNh5VZn
         Z6vjacQjBAa2wzsshJbw7ncrlrgEizgYes82QNy/dFRBmFX1z2hF7H/yf5LmVHVlNwp4
         AegA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:auto-submitted:mime-version
         :references:in-reply-to:reply-to:from:dkim-signature;
        bh=l3ZauplVVqH0KCCwaXuS7roK1JzTO7jEMocOaMoVsGI=;
        fh=eyazKJzkNXsAk2KFa5rWlWtPeUKRoBwUzk6t150vj0c=;
        b=SlwseI51mWOob/NCHitCX/PO5RSDKDO2bNNfMPN0qCg73DsSLpkB9iSDpdXli6vwgR
         ryxbHTiWD6pFlqer+BKv0YUwkPtvalkAbc/vjBj/eVrgmSt5pe2KFrBc07j8F0KHxKRw
         j/3rBXaF4b6qZBFMAr4/8hQNAarTYTG4gerHDzq0bdoWUChgWhQrAPqWrbeDcrcOAtHC
         2ixJUdSzxi9BYJ4UdtI50shwxHn+BFwdybq/1OoFjlFqL+ujBGbDvumHlpLWsAk5CzDt
         uJ7FBacUT+LaPz2ys57NFlRVVo56xXiEX3RWsTDak7yWASGwud8won6w0p4H+EB2n9Jy
         5AuA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774675010; x=1775279810; darn=kvack.org;
        h=cc:to:subject:message-id:date:auto-submitted:mime-version
         :references:in-reply-to:reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3ZauplVVqH0KCCwaXuS7roK1JzTO7jEMocOaMoVsGI=;
        b=Gf7HM3/IDbc1T7aa1dnlFmT49j7ORF8QPvZoTWTTmGarNgwEq2tC0NcCN2y8rwQLxM
         lKpK/1krIC3Kg7+UHENfXEnj/YJEm0UhQwGplwcuTcnmfoRaHKeMVy+ACoEqUiBeg+AM
         JAXnpjoUGAm8j+5iEU0EVh9/qqNoyhdqXEyG3gdPMCx1UvoEaG5mus3VCuVRVHSVAXQv
         Jxff5U+F5DT0ho8JBpPKUdLQNkC5x7bETJeq7Gu4LJJETh0wHVOFOnJ+y+l5Z25HbnH9
         oMpO9B4qC0oWoaM8uS1KzNix5EG5FpdTaFVGPlddrCINy+12SKb0AU48tYHqMqgASqaG
         GlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774675010; x=1775279810;
        h=cc:to:subject:message-id:date:auto-submitted:mime-version
         :references:in-reply-to:reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l3ZauplVVqH0KCCwaXuS7roK1JzTO7jEMocOaMoVsGI=;
        b=MvJz3SP7WrxU4GWZ7cLqrrfbDeLIZxCLnA5UToYFmu/CTGxk4yQrFqj5SL0CoQhc8G
         KR7NlGWaQfj26esexJxy0baI///WWJo6E/QLI6oszfUATMiNa/nCAQ+LA5Jmu9XVkChF
         H366rEEanhbYY+jiBbKwMPSPjenbTsISVD+tOuHWHQI7Y1nQofACKpGUlkZwLwpKIoeP
         XmnN5vYZ55vEHcqPahKfSFSggkImsiKtLz4zQYbgNBH84fC35NtPqHDly2OJ4MkaMpv/
         iAzaLBeMN3Br3SAXa0wFe4wwC2c9qa1Tl53/1U/SiUZd65BLSXFZ9WPLr9/eCjKyiFk4
         SZIw==
X-Forwarded-Encrypted: i=1; AJvYcCUAGZgzHodjc9lflcfE1cGC27kYvrpxx4UgFOQPv4dPBMoTRu0zr1qORNeHo0f3ozZJ+5jwgxeAFg==@kvack.org
X-Gm-Message-State: AOJu0YwmYuOs2+8vh/XTTyoeEwgPue9XSQvYNkeAKyE4NCq98bRbFd0q
	VrsSigwDJAHiJ6DW7CskYoF689e51PcOgDPB+G0Ux+7FRibYy/P1DTBVE48O+uN+wUhhuLoTWd5
	5AUy3cHG9KvZcRGbteIwRo3IlES5yudQ=
X-Gm-Gg: ATEYQzxiaGIi51MLgy/EK+O2CxqslXdlOiwWlxvUWg3pljnpOOUapqlorPy+lrgwlES
	pglrlWWbUkb9ZNco5Rr6Ehp4SZnMNe83yXvUxQMrda74J5JIOCoOQnELrEoi7eFCSHiPDYSCXxB
	fruCRlvbsYkzv0IvDzBAyI8Qg2o57VYLAz+zue19nJQW103055hNDV+vclE03bzDRYEXl7dNaQJ
	QJEHpYMt3Bwi99rSP2AOQR0XLo4p1cZXjmcBPPJI0i9EvzZRfHVAcSOINYw6wJ6JXsxzE1r0sw1
	M6jjApn7
X-Received: by 2002:a05:6000:268a:b0:43b:8fa4:1958 with SMTP id
 ffacd0b85a97d-43b9e9d6039mr8196348f8f.4.1774675009911; Fri, 27 Mar 2026
 22:16:49 -0700 (PDT)
Received: from 382830561574 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 28 Mar 2026 01:16:48 -0400
Received: from 382830561574 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 28 Mar 2026 01:16:48 -0400
From: Yail <tahernady45@gmail.com>
Reply-To: Yail <tahernady45@gmail.com>
In-Reply-To: <69c763b5.a70a0220.128fd0.001a.GAE@google.com>
References: <594Z9JP5X6G@zendesk.com> <69c763b5.a70a0220.128fd0.001a.GAE@google.com>
Mime-Version: 1.0
X-Delivery-Context: automatic-answer-34378216055314
X-Zendesk-From-Account-Id: eff5728
Auto-Submitted: auto-generated
X-Auto-Response-Suppress: All
X-Mailer: Zendesk Mailer
Date: Sat, 28 Mar 2026 01:16:48 -0400
X-Gm-Features: AQROBzDE0hYHx42DcZYO5vjrjCQPDkengQn1W1PWNZug0TNfsd7igBJ86Z0rIaY
Message-ID: <CAApBg0E-Y7ve999+Y+aAQ2uNr8mSLu6m=vKFnrUEyVcKw7jByQ@mail.gmail.com>
Subject: Request received
To: syzbot <syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com>
Cc: Akpm <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, 
	Hannes <hannes@cmpxchg.org>, Linux-kernel <linux-kernel@vger.kernel.org>, 
	Linux-mm <linux-mm@kvack.org>, Mhocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Netdev <netdev@vger.kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: multipart/alternative; boundary="0000000000008ec03d064e0eb9b4"
X-Rspam-User: 
X-Rspamd-Queue-Id: A822E40002
X-Stat-Signature: r63n739aa6f8wsctkhb8jppxggpi4awp
X-Rspamd-Server: rspam06
X-HE-Tag: 1774675011-64985
X-HE-Meta: U2FsdGVkX1+ARZ8eGuj2vtPt3VSDVDwSMTLf04rKE2WexyROTWKFn/Iv7BxMInQNJVlL6UVbzHT/ovQSm2FWPMBAqXysUaadmys8gN6Pqgke+7nLq25nB+PD6aihja9iHZZc9LC6R0XbLqLFU58HSrbrwH4g3eL8EcO9Vfz1xNiLXT6WuprRyvLuf/yqJzMAXo4IgH1VOd+EahhgJ9eqIzbgBh31vrtW1MGOmLDV1RNJswico9KWgImmm5ogioE7WwC6TtB15i0kVXFGD8Vq4+mPbA8oh/2r40sxWMSWsGAwvsBfXcb4RoVP+bxR6MenQnvb/zVAiy6+agSBWes1hVVWnmnxYt8jsb7cq1Bp3m1F485JYbfEyK3bN8PlETORQZ74d663OYdEUuijbZ/3V8QemknJ3hr9yG2Vv+qhT56eIBNGcXakTBJppHL2fnPOebtXD/06QgRGDelxqlnKrT+zI+78vAqoLANeuOIo73AJYIgEiAxiIiBl6+5gtfFs0fj9NgSA2hTKj/+XHIpYdcK7//wnsXtFCOeCHxBhkf9C3nBy4MFTOU6wj8ztzRG1YXsSpfAtzlc1TxRxlQAS+ipYv5N6aEc7crFv0skUXRcFz0gmf58EGz40XdQKdKMMdpSl0/G14QAGT0lbpb1HYM5pa4F/KWykqrKbGcX1zLZkptm72YGwhhRqeQBQXcCbe3++T8cTBJcEJlRwr6ERKbIecCr2UEs+RKL/6JHMlVl+hLoSxskSXygpqDE2TzmcZQ64p9U86MXnpA8YzB88QMvugJeMgtzTGDpBzadeDYjXhmeJu7H2rud/3dMysWyXBCoZjWt4jQq/LxvBIM3AzJAW6hijaSxoShDfbj50F5EXlYxUqf+wp+K9YFrTLmObOl9JEDWeOqragM3m+4itNT1PmEEokgjBk8yacCoKXcgLnNt+jroZ0YnAxPsNr2i2aE76AJQutr0zmTI1sgz
 /S6uWenW
 WriKsyK0H5fYX2FMalo7mfGr6GCarS4GPvR7qws+ZXRxJinHvuqQS8YL6XnpIX2mhCSi3c/VZvJg/nenm25wNgT+1wAe0i4hrBThZuP21fxYbJdsG3c0Vt2bFbqPqF8YA0IkaqApgrFR+13pxNiMeCvOzmx2W0AyRsDln+JHCREddPxeDUnsW6WGi/0UL2jauzEurW4MsIGa74lkhw1AVuhK2oIED6SxXPd+T1TOHtfuknk8ds6hU7EQ77qfWR87fTqgK8YZZgfw+cnUB4GNK9F08hR5gzwHvk785f344kJ4uWJF5AmedzQnaKAbx9VUTOqtWV5Jb3K2Uw76VBVAekw6wJ+ok5pRPhKH+cJLHCRQi/zDIN2wx/DXZiYlB0bQwWvOyCYlULscKdCOZ+O1pRR91O2Qsvg9vGcEHj+jqLrHIGH4dINuEmpnRRSbrQZIqVOyVUe1JsTMuxFZJ0td2asHa5POa+emEb4Mq6bXgP4Hw5kbClgQNbzBG3L4jQFAFTRnzvNP+Ie9iJ3Fw6BRZVxDAQ6R5qmHElTh8VWapc1nowIzDyKekZ6YiIByFb/UsCZSHs3D2HLCwQz9ATpgRpsmkCUqVzhLPuKPyxLZ4xJUzDDiyGgb2QzL34X/bEVAPcZAeNR1b+2xNQpu9LEzJMECJXCPfStngFVXdaV/+WqCxZ92JCs36WROI5AWdZjbgDV3iFwbvJ9Xavue6XdVhpw7+DcA7WcS/U7/XCzUttBtwdFQJjJbcITZBkc9SobdkBe3W3HlimJvUeGoQS5WKaURQRBUFnNCqGOzajNAvL/dbJq6pkivbhWspKWS7R2g8s0x2uRgnuGtEFLsDpZeb8uNIQ4bzkP8qcKfSyJFM9Embunu8Roj+5n+jP5gnjjxnq1kTFAI6/H2OO6g5VVX/zi6MffLoQ/cS92eGM6/Y/9UPogw6Fx+PRN2KveqOCzsIMA+iWkgx0Dn9yY56hhmMBVWzaC7D
 rLCmxge6
 lBRwNGG5HO4HEr5e08ycHmLPli3re4peCOupTSPsOiABWZ4c49+eNw9ZIUP38THvU1+M0Jg/V2zdkZFV2xHmp8MhRebqjiZDp6II5lO3QQOaEL7knrl9/gvWUAJ7VOOtFrHyFv3KUsxKFrFtWUdAvNgnp2931EjTq7ZyETF39S4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000008ec03d064e0eb9b4
Content-Type: text/plain; charset="UTF-8"

Your request (53) has been received and is being reviewed by our support
staff.
To add additional comments, reply to this email.

This email is a service from Yail. Delivered by Zendesk
<https://www.zendesk.com/support/?utm_campaign=text&utm_content=Yail&utm_medium=poweredbyzendesk&utm_source=email-notification>

--0000000000008ec03d064e0eb9b4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


<html dir=3D"auto" lang=3D"en-US-x-1">
<head>
  <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dutf-8">
  <style type=3D"text/css">
    table td {
      border-collapse: collapse;
    }
    body[dir=3Drtl] .directional_text_wrapper { direction: rtl; unicode-bid=
i: embed; }

  </style>

          <style type=3D"text/css">
            @media only screen and (max-width: 768px) {
              .simplified-email-footer .namecard {
                display: block;
                min-width: 100%;
                padding: 0 0 16px 0; }

              .simplified-email-footer .content {
                padding: 16px; }
            }
          </style>
        </head>
<body style=3D"width:100%!important;margin:0;padding:0">
  <div style=3D"font-family:&#39;system-ui&#39;,&#39;-apple-system&#39;,&#3=
9;BlinkMacSystemFont&#39;,&#39;Segoe UI&#39;,&#39;Roboto&#39;,&#39;Oxygen-S=
ans&#39;,&#39;Ubuntu&#39;,&#39;Cantarell&#39;,&#39;Helvetica Neue&#39;,&#39=
;Arial&#39;,&#39;sans-serif&#39;;font-size:14px;line-height:1.5;color:#4444=
44">
    <p>Your request (53) has been received and is being reviewed by our sup=
port staff.<br> To add additional comments, reply to this email.</p>
  </div><br>
  <div style=3D"font-family:&#39;system-ui&#39;,&#39;-apple-system&#39;,&#3=
9;BlinkMacSystemFont&#39;,&#39;Segoe UI&#39;,&#39;Roboto&#39;,&#39;Oxygen-S=
ans&#39;,&#39;Ubuntu&#39;,&#39;Cantarell&#39;,&#39;Helvetica Neue&#39;,&#39=
;Arial&#39;,&#39;sans-serif&#39;;font-size:12px;line-height:1.5;color:#4954=
5c;margin:10px 0 14px 0;padding-top:10px">
    This email is a service from Yail. Delivered by <a href=3D"https://www.=
zendesk.com/support/?utm_campaign=3Dtext&amp;utm_content=3DYail&amp;utm_med=
ium=3Dpoweredbyzendesk&amp;utm_source=3Demail-notification" style=3D"color:=
black" target=3D"_blank">Zendesk</a>
  </div><br>
 =20
</body>
</html>

--0000000000008ec03d064e0eb9b4--

