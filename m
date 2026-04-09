Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F8AEE98FDD
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898A26B008A; Thu,  9 Apr 2026 12:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849576B008C; Thu,  9 Apr 2026 12:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786CE6B0095; Thu,  9 Apr 2026 12:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7366B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:23:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 181E0B9ED9
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:23:16 +0000 (UTC)
X-FDA: 84639537192.17.887C152
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf17.hostedemail.com (Postfix) with ESMTP id 600294001B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:23:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775751794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DYA5t76/c8UnqjfyPHPmuppyQxanOdhe8e571Dwgiu4=;
	b=BaaCCdebLWjsmqY/x0N1358FquqCFhUWrGE2PEg+Nar56z8iFkxaHr8rZIS/v9ukYzG+sH
	FNs/WEfCjwM8GpiDaWtpTt9KYArUKFD86YqiVNbp/ksINfuv/1lJba6gq1FkOXQt/0xOqO
	dn8YVf8WvagkCDzDuKfsDG77TL4VF9I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775751794; a=rsa-sha256;
	cv=none;
	b=aLBrzaorvUurzUu2f/crB/wifKd5fXJiU+7/oM6BcH35kt9NXIRCKp/Xb3hP9H9lt96Bk8
	NYfQMJ+NeOFwLKUUnrCrKcshsIBxRy7/iFN9nnlUqRghfPbANbboYRXNO89orRAXZ1PfeW
	iAYiqh+dYSo3yxHsv+WH5Dxt2K3glbY=
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59481E2D38;
	Thu,  9 Apr 2026 16:23:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id 4AA5220029;
	Thu,  9 Apr 2026 16:23:11 +0000 (UTC)
Message-ID: <c30a3fe0a6c412b1d0092a2eb4d4d878288ca935.camel@perches.com>
Subject: Re: [linux-next:master 8662/12838] htmldocs: MAINTAINERS:40:
 WARNING: Inline strong start-string without end-string. [docutils]
From: Joe Perches <joe@perches.com>
To: Matteo Croce <technoboy85@gmail.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, Andrew
 Morton <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>
Date: Thu, 09 Apr 2026 09:23:10 -0700
In-Reply-To: <CAFnufp0qW40DrZPG5akNaoXanRNN2MBW2ougcwThtzAXh-z5VA@mail.gmail.com>
References: <202604090741.1kUVXMoc-lkp@intel.com>
	 <CAFnufp29D4VdTgoJ4uDk-dQ4-RuO_C6=TQ7O9TA5M=JSe1j+cw@mail.gmail.com>
	 <1c7e8c605d2373c26b08d0eb64cc56efd69dbc26.camel@perches.com>
	 <CAFnufp0qW40DrZPG5akNaoXanRNN2MBW2ougcwThtzAXh-z5VA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/Iu0p2ACSkIh57WQTpSy6roLh7BVn0s4I=
X-HE-Meta: U2FsdGVkX18VL7pyAz7WgbByp+2K7LHFPmvcPDJcmZYAUwV/Tvv7vQ0beBGyaXFhKM2mJ/1M/WQbJjUAxOI5tWaaDSo/40gGbZPbyJ4aP7eyjImGMDS2BGAHzr797+0OGR//Em3O4FTsxY6kFYbVeLmewT7fRBknRVaktNkX+mMHOrNhNdNIpf0EC/DdWM+zFocEnY/HwevMtQ6H1pr8UKVGUh75J9UFAeNHPUTnEYoDTCx2mUFFnpkHpKOW9mvXkwpUOcVRvhVnzpBL4jcnPSEtLfJgdGQgQIyzt8orcaTiYegLvI2jZyogCkVwq1ADN28V+7PKPNqGsS1enll9p/Lpl6gaVqF8SLLcjA5Jg9gjxCdQuHz7J+wsIAqB8T6u
X-HE-Tag-Orig: 1775751791-552619
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 600294001B
X-Stat-Signature: i7fxoifpr67kazbu5cbt8exxg5j6geix
X-Rspam-User: 
X-HE-Tag: 1775751794-631480
X-HE-Meta: U2FsdGVkX1+P5s0NWcqXD45bIPSpf5Ongtbpa0pB4ADIwt2SeM8RjXS17hO2IXEimdDLtbo+8Ag6bb8T3JLzYylhLD2531rqvwaOxyOC1LQfIROfPMxD21bN30u9Usp54ge+a5g4oR9p+9ztnjcv8FKUij5/O+ay6jVPpp/F5AiLhgll1JeTl0vE8/O+m9CSJ8mngL7mwtbiRR394fDWEedPwPyBIIK30AGd+lLX8NJiDTMKkRP9qYc/ri9E/GTb6m7BirAxzG1+ezOtl1JjmFbLoWVfIr0SAO9hwBwRiqDihozRpoxwrxgALXeoPBcPPinBzJGzIWH7/K8QsABPxeFK8dJX8KCYy/Rb1AUmiY6N3nWv7MrfziTD165V4G1u9nLR90IHbiD/jHiKZjq780OoTIYmbY8v3KxrYTClnrjPa0+aeg6MGh0cHVdkG874wLh8M5NTVF4zJ1XEUeXkYCy3UOiDwd3nkEFwFdjRfBbBvcCHKQfAlzfkpGGSCGoLYvtFfQ9CTtF156wmRraVD7hxnOAMhE5M3NwSI6w/HOa/G90pSEYeMriK3rEvvQy0gFIXmbpuDmB5c88RgqnTzAJUZpR/i6eDVkchQOUl/c8rXTVjIbLcsPXgcLPl9WfnoaEWamxa1eOyr+aBTHfEQgdimn3Obd4nikXFK+x+09x4Lwout9PcVp5HFO2TqhObQxFxtqw0JwR+LdjsRsuncg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-04-09 at 18:16 +0200, Matteo Croce wrote:
> ```
> Il giorno gio 9 apr 2026 alle ore 16:47 Joe Perches <[joe@perches.com](ma=
ilto:joe@perches.com)>
> ha scritto:
> > On Thu, 2026-04-09 at 12:12 +0200, Matteo Croce wrote:
> MAINTAINERS:40: WARNING: Inline strong start-string without end-string. [=
docutils]
> > > >    Documentation/userspace-api/landlock:480: ./security/landlock/er=
rata/abi-4.h:5: ERROR: Unexpected section title.
> > > The problem is that "**" is seen as start of a bold text in RST.
> > > Escaping the first * fixes error and keeps the glob unaffected:
> > >=20
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -35,7 +35,7 @@ Descriptions of section entries and preferred order
> > >      F: drivers/net/ all files in and below drivers/net
> > >      F: drivers/net/* all files in drivers/net, but not below
> > >      F: */net/* all files in "any top level directory"/net
> > > -    F: fs/**/*foo*.c all *foo*.c files in any subdirectory of fs
> > > +    F: fs/\**/*foo*.c all *foo*.c files in any subdirectory of fs
> > >      One pattern per line.  Multiple F: lines acceptable.
> > >   X: *Excluded* files and directories that are NOT maintained, same
> > >      rules as F:. Files exclusions are tested before file matches.
> > >=20
> > > should I create a fix patch or we can still amend the previous in net=
-next?
> >=20
> > nack.
> >=20
> > this shouldn't be fixed this way.
> > betterwould be to not try to format things that shouldn't be formatted.
>=20
> what about escaping it here?
>=20
> --- a/Documentation/sphinx/maintainers_include.py
> +++ b/Documentation/sphinx/maintainers_include.py
> @@ -89,7 +89,8 @@ class MaintainersInclude(Include):
>              output =3D None
>              if descriptions:
>                  # Escape the escapes in preformatted text.
> -                output =3D "| %s" % (line.replace("\\", "\\\\"))
> +                output =3D "| %s" % (line.replace("\\", "\\\\")
> +                                        .replace("**", "\\**"))
>                  # Look for and record field letter to field name mapping=
s:
>                  #   R: Designated *reviewer*: FullName <address@domain>
>                  m =3D re.search(r"\s(\S):\s", line)

I didn't know that file existed.  Fine by me as long as it works.

