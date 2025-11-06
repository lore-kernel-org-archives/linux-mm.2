Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C6BCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 09:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24418E000D; Thu,  6 Nov 2025 04:09:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4DE8E0002; Thu,  6 Nov 2025 04:09:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C120A8E000D; Thu,  6 Nov 2025 04:09:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B42498E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 04:09:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43F9413B681
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:09:47 +0000 (UTC)
X-FDA: 84079609614.11.BA586B6
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 53326140005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:09:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZPpFycxL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762420185; a=rsa-sha256;
	cv=none;
	b=oQ/z8lv7dg39951hSbf6fZdB7laUMT1N2a5uCo4Vyg43z1b/YdtydExqoIVSJXdTL2k4vU
	Hc7hVtDWSoMLfPpFsYmqgR1v+OTzgh7TiZQtq0quqX3ekQk0f6Vq8JKsiiQVi4/wcipHkZ
	Ej5ecyOm/L6hNIor5YCQLt68CrnvDwg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZPpFycxL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762420185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRMNgmont7IgVwl9qnGUPPyEimnvNx1oY9lAMYcS58E=;
	b=fJMRNavRN3mvMIi5P7I6gfT5MERyl2LT/QlVCx1mQG3AgpN+1t9fB/0kuYbpa4fAQHY4LS
	InsxUt60DqTDS81OguUsgB625E9qqVQPTEndyT1eWGK+g1xP35z0t1ykCDjwZxli9XQ6Zi
	rerONg57+xJJ4+Bd0vUHSyU4B/sE0Yw=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7291af7190so77576466b.3
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 01:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762420183; x=1763024983; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VRMNgmont7IgVwl9qnGUPPyEimnvNx1oY9lAMYcS58E=;
        b=ZPpFycxLXxFGLU1JHZMiVjM52Xw+rUznEEzhbMftaKW056S+zsNdGoKjwdZlJAebBk
         wIvQuvZR0w6donYF68Z0HolY4Aa+mhcUOtP90aT9O62o/SPs6uy5smbpwU0gJhHpL953
         63kWHm+vNcSvf7QUqQxmFzaKQmSta8gksTiC7hgA2FwRu7S5s/Rk57BYxVcrMkXSmS1p
         BlcHLRp23DSNYn+JK+RRz6zZ/zBUipcc/Dh16AwNoLihNXlLvkYE8jWczhnZzoVZ+XMP
         c2TStoZaliNjMLDwB1Gz0Q7snmpw7IFNbaZ0efsvbMUoGbRWjrpPGTbnEPJYRcrqodRe
         7Z7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762420183; x=1763024983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VRMNgmont7IgVwl9qnGUPPyEimnvNx1oY9lAMYcS58E=;
        b=g1Ma+WrIpgzATary2qDlykjdXIKcQzkpAvY5IfeGB6C0IefoBtkh+LJk55Z21hPvLa
         IqkxGfukQYrFaWRAjj+fRhsdwN/C1PFtfGmZLo+oTlUFGCmBfnX1JYBOCLkZScfh/nAi
         JpkbIT1HZY2RjvvXKxXEYhxtOGLK//AHXIyt//rPDXHf+lahmsgOxqTegMOqmCAY28fe
         i0SSY+ca3APf4xc3lssuYWemVEVQBwIu16YbaEOQdM+RXZ0Ce/IYLMqMUnTUTGeLZWt6
         T0QtGwvaoFvSxagyEEchGocqgzo+XBWAWZiRSn2awq34i1LOsx5sxwfAi3GR3JDM7frd
         i52A==
X-Gm-Message-State: AOJu0Yyf7LbL69+3FDz4mkG4nrvuYdhedjhr7fxG311I+LHZ7s9wRX/n
	yz/Gxi/rufX+yRhppeIBFYPD5PgTpNOpN1tl4VfxO514TtkhSctpuOALxcnHe4yvoL8=
X-Gm-Gg: ASbGncsHW+SFsdFgpsSpvM97aImJyeM3BI7P/0a+LgaQ+1xL70/wOEu5fkRWVZPVK9J
	4fJKPKzqkl47Xtg4vY3LuIMIC/RTqIhuhVn0+4spWMzuOzXFkDRx7jyOG2LmHxREIKIpqHBV3fD
	h/Lx8bRbE2ng5jhjskLHsLcfl9Z03uvUzyRbC9ymdzGg6uduzfnaaAu2kfw+RKKSOqKYv2tzsBw
	nmk5sJyVFd11eS1WTJYlQ+0xitbTcZNPo/b4lwnYcmeXqL309GpInxWtgtzCgddWRNvce3vpiWl
	x9MoUUxx59ZScvbNTCadsASM0IY/kfA1KHJXGENvO/VWEDLA6C9RKUiCywhGi/spTv58Hw8QQFq
	ErJEDfjbnuQojHnaivQnoVFTiNzSvZy4gI8+Iic4ZwOL6w2cj0zHr6DIH7w99h8iJChjA40kOmu
	JgdGZybfjmXlHUUQ==
X-Google-Smtp-Source: AGHT+IGWIwUJw8AUjr0vFraqyyD//Jj1PNVLmvlu/ItjX+PaA6mUvXXTfUULBc/crgWlJQF5efqxRA==
X-Received: by 2002:a17:906:7944:b0:b3f:f822:2d9b with SMTP id a640c23a62f3a-b72651557b5mr720415266b.9.1762420183629;
        Thu, 06 Nov 2025 01:09:43 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7289334101sm170946766b.11.2025.11.06.01.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 01:09:43 -0800 (PST)
Date: Thu, 6 Nov 2025 10:09:42 +0100
From: Michal Hocko <mhocko@suse.com>
To: Robert Dinse <nanook@eskimo.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Folio Related Stability Crashes in 6.17.5 and 6.17.6
Message-ID: <aQxl1sXTvhIB753a@tiehlicka>
References: <b964df0f-45e3-4fea-a84d-852869b49502@eskimo.com>
 <aQxX1HdOnVZJAERp@tiehlicka>
 <41d1cb48-7711-690e-c9a2-978e0f96f5d6@eskimo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41d1cb48-7711-690e-c9a2-978e0f96f5d6@eskimo.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 53326140005
X-Stat-Signature: pm5oar1hk5398mcos7rrn1bhns8wcd33
X-Rspam-User: 
X-HE-Tag: 1762420185-251879
X-HE-Meta: U2FsdGVkX18X7jJfgqQPiijcECnH/Yp9kk1ldfmk8JwzbLukeXG6WR9Of0KMPJTBpPWp03qrCOHoGkh9VFwY/E47ODbx2FzcDArM1+YzMipHq35ptGO0sJsIp0K3nYjRX+LRY8jA2a3EJbfguA77hUZBpWvu9iC5EclmYFECZmjRX0tzujZX4xHX5Qc7V8xehNs00pUCPbZ7o74GOQij2jms4fEK/Ds3EN2CY5aI8RJ987phwMRrFwkdXKqKIPI1s6MDsb71ia9sM4nRQcyno51bThw+8nFAXKJ1VN0JPJAWMGdC8WEUWY2t3AB3dDiMllvY/BfX9I7NPEBICkln2qI3OB+Aeoa3JMMwT2wwEpRkRLhaIiiBDufDu098pvZP5+GMhi71vN9qDRbMKymjvlvmSc16YvuHyFEG91fVUj2NmG1I+2OUJm25W1xueU48LrAv26+8GH8B+C8rgR/s1cgu5Rrc9p1aEBUqSfIFC2rvIlF7/kymUz1uZGECeqw7c/9ho3FhZpZwItbHg9XKWyF8HKrItljlQEeAu0/+PXJUksW3tnGczfaIGNqTXiCgsSwhzZ6V8+hagQLlrHsk+UQfEo9BZzOUutnku+Jnyd/yfY8ePp7iBhyc0fF+9UTj4jlHZ305NMXD0HazqXg92QRM1r0uqCp1dzyxwVMUbJmLjakstB6WadoRPPIiZGSNr9J/wUnCqpwc8EvL6sp6D0lyRQ2kQ3I8moGYgEXZH2L6D2oJMBjXNRnS96TVA/sQEffmfmbmL8tryH1adQHmZ640UZ3ZslJIsDDlJRRCEOkKYYtzBjcveQKcqFIVMfACHu3XtWrUg9oYOScPdcqPK8rIx/o1c1YJ9ZJnfHX/zoIFjSpTbGWNZ1p8tqiJhJtz7PQ4rmS/+ZKI9r6VK5S7nkIawku/3UVHPJOBnJIxaL1ZLnD5sYwm+K3BX2nMBi7hqOTYygIjL3X+EB5tGIR
 QBpyRPG1
 NO4enmUsLHI1TYw/7+fx2BGEuJ3JVy8OF649jF3fWyG2wu5ekvFm5diou4miTDRDwBMdwfM8p20pXx7N/trZvzqro1/aC6bLRmcrsDGTjeSIf9a1TV6OJTGclYepoV0Nyn3MBQUL3zrjaJSfJt1MNZbZ0eUSgDLu/Guyfvs1iIviWbhJISz7PgQznzA6wMT9bH+GmMw746Zr2Of4TheN+fyYjo3GSCyb3+kUeG+UyjL8Mh/YquKrj2q3apdmVpJsutN+6p/H81blOypYgNWlTw2Kr31i22csFe0aQo2WtDDiXKQ2LFJAQ8xIM4VGQVWMXS600uZz5O0ObdL7JVTT503eU9Zw4QS/Sowua
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 06-11-25 00:24:36, Robert Dinse wrote:
> 
>      I am installing 6.17.7 presently, I was a little resident to install
> the current tree on a critical machine.  If need be I will.  Also, I do have
> a crash dump on the last failure if that would be of any help.

Understood, I am not sure who is going to be willing to debug this on
top of stable tree if it is not clear whether this is a problem in
vanila tree as well.

-- 
Michal Hocko
SUSE Labs

